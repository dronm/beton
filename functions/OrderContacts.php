<?php
/** Order-contact persistence for Order_Controller.
 * Requires the existing orders, contacts, order_contacts tables and contacts_upsert().
 * Caller owns the transaction. Never deletes records from contacts.
 */
class OrderContacts {
	private static function id($value) {
		if ($value === NULL || $value === '') return NULL;
		if ((!is_int($value) && !is_string($value)) || !preg_match('/^[1-9][0-9]*$/D', (string)$value)
			|| strlen((string)$value) > 10 || (float)$value > 2147483647) {
			throw new Exception('Контакты: неверный идентификатор.');
		}
		return (int)$value;
	}
	public static function phone($value) {
		$phone = preg_replace('/\D/', '', (string)$value);
		if (strlen($phone) === 11 && ($phone[0] === '7' || $phone[0] === '8')) $phone = substr($phone, 1);
		return $phone;
	}
	public static function normalize($value) {
		if (is_string($value)) {
			$value = json_decode($value);
			if (json_last_error() !== JSON_ERROR_NONE) throw new Exception('Контакты: некорректный JSON.');
		}
		if (!is_array($value) || ($value && array_keys($value) !== range(0, count($value)-1))) {
			throw new Exception('Контакты: ожидается массив.');
		}
		$result = array();
		$links = array();
		foreach ($value as $item) {
			if (is_object($item)) $item = (array)$item;
			if (!is_array($item) || !isset($item['contact'])) throw new Exception('Контакты: неверный формат строки.');
			$contact = is_object($item['contact']) ? (array)$item['contact'] : $item['contact'];
			if (!is_array($contact) || !isset($contact['name']) || !is_string($contact['name'])
				|| !isset($contact['tel']) || (!is_string($contact['tel']) && !is_int($contact['tel']))) {
				throw new Exception('Контакты: укажите имя и телефон.');
			}
			$name = trim($contact['name']);
			$tel = self::phone($contact['tel']);
			$length = function_exists('mb_strlen') ? mb_strlen($name, 'UTF-8') : preg_match_all('/./us', $name);
			if ($name === '' || $length > 250) throw new Exception('Контакты: укажите имя (не более 250 символов).');
			if (!preg_match('/^[0-9]{10}$/D', $tel)) throw new Exception('Контакты: телефон должен содержать 10 цифр без +7.');
			$id = self::id(isset($item['id']) ? $item['id'] : NULL);
			$contactId = self::id(isset($item['contact_id']) ? $item['contact_id'] : NULL);
			if ($id !== NULL && isset($links[$id])) throw new Exception('Контакты: строка заявки повторяется.');
			if ($id !== NULL) $links[$id] = true;
			$result[] = array('id'=>$id, 'contact_id'=>$contactId, 'contact'=>array('name'=>$name, 'tel'=>$tel));
		}
		return $result;
	}
	private static function quote($link, $value) {
		return "'".$link->escape_string($value)."'";
	}
	private static function matches($contact, $value) {
		return $contact && trim($contact['name']) === $value['name'] && self::phone($contact['tel']) === $value['tel'];
	}
	/** Resolve contacts before the order write, inside the same transaction. */
	public static function prepare($link, $orderId, $items) {
		if ($orderId !== NULL) {
			$orderId = self::id($orderId);
			if (!$link->query_first('SELECT id FROM public.orders WHERE id='.$orderId.' FOR UPDATE')) {
				throw new Exception('Заявка не найдена.');
			}
		}
		$result = array(); $seen = array();
		foreach ($items as $item) {
			$linked = NULL;
			if ($item['id'] !== NULL) {
				if ($orderId === NULL) throw new Exception('Новая заявка не может использовать строки контактов другой заявки.');
				$linked = $link->query_first(sprintf(
					'SELECT oc.contact_id, c.name, c.tel FROM public.order_contacts oc JOIN public.contacts c ON c.id=oc.contact_id WHERE oc.id=%d AND oc.order_id=%d',
					$item['id'], $orderId));
				if (!$linked) throw new Exception('Контакт заявки изменен или удален. Откройте заявку заново.');
			}
			$contactId = $item['contact_id'];
			if ($contactId !== NULL) {
				$contact = $link->query_first('SELECT id, name, tel FROM public.contacts WHERE id='.$contactId);
				if (!self::matches($contact, $item['contact'])) {
					throw new Exception('Данные выбранного контакта изменились. Выберите контакт повторно.');
				}
			} elseif (self::matches($linked, $item['contact'])) {
				$contactId = (int)$linked['contact_id'];
				$contact = $linked;
			} else {
				$name = self::quote($link, $item['contact']['name']);
				$tel = self::quote($link, $item['contact']['tel']);
				$contact = $link->query_first('SELECT id, name, tel FROM public.contacts WHERE tel='.$tel.' ORDER BY id LIMIT 1');
				if (!self::matches($contact, $item['contact'])) {
					// Reuse the application's existing contact-upsert behavior, not a new
					// duplicate-creation rule. Directory edits follow contacts_upsert().
					$link->query('SELECT public.contacts_upsert('.$name.', '.$tel.', NULL, NULL)');
					$contact = $link->query_first('SELECT id, name, tel FROM public.contacts WHERE tel='.$tel.' ORDER BY id LIMIT 1');
				}
				if (!$contact) throw new Exception('Не удалось создать контакт.');
				$contactId = (int)$contact['id'];
			}
			if (isset($seen[$contactId])) throw new Exception('Один контакт нельзя добавить в заявку дважды.');
			$seen[$contactId] = true;
			$item['contact_id'] = $contactId;
			$item['contact'] = array('name'=>$contact['name'], 'tel'=>self::phone($contact['tel']));
			$result[] = $item;
		}
		return $result;
	}
	/** Keep legacy single-contact consumers (SMS, reports) on the first row. */
	public static function setLegacyParams($pm, $items) {
		$first = count($items) ? $items[0] : NULL;
		$pm->setParamValue('descr', $first ? $first['contact']['name'] : '');
		$pm->setParamValue('phone_cel', $first ? $first['contact']['tel'] : '');
		$pm->setParamValue('contact_id', $first ? $first['contact_id'] : 'null');
	}
	/** Synchronize associations after the order has been written, before COMMIT.
	 * Existing row IDs are retained, and new rows are appended in input order.
	 * Only prepare()'s result may be supplied here.
	 */
	public static function apply($link, $orderId, $items) {
		$orderId = self::id($orderId);
		$keep = array();
		foreach ($items as $item) {
			if ($item['id'] !== NULL) $keep[] = sprintf('(id=%d AND contact_id=%d)', $item['id'], $item['contact_id']);
		}
		$sql = 'DELETE FROM public.order_contacts WHERE order_id='.$orderId;
		if ($keep) $sql .= ' AND NOT ('.implode(' OR ', $keep).')';
		$link->query($sql);
		foreach ($items as &$item) {
			if ($item['id'] !== NULL) {
				// Changed selections were removed above, so swaps do not violate the
				// unique (order_id,contact_id) index halfway through an update.
				$link->query(sprintf('INSERT INTO public.order_contacts (id,order_id,contact_id) VALUES (%d,%d,%d) ON CONFLICT (id) DO NOTHING',
					$item['id'], $orderId, $item['contact_id']));
			} else {
				$row = $link->query_first(sprintf('INSERT INTO public.order_contacts (order_id,contact_id) VALUES (%d,%d) RETURNING id', $orderId, $item['contact_id']));
				if (!$row || !isset($row['id'])) throw new Exception('Не удалось сохранить контакт заявки.');
				$item['id'] = (int)$row['id'];
			}
		}
		unset($item);
		return $items;
	}
}
