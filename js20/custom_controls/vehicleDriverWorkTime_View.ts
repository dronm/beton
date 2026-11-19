// Compile with tsc --strict --target ES2017 --module none vehicleDriverWorkTime_View.ts.
interface VehicleTimeControl {
	getName(): string;
}

declare class View {
	constructor(id: string, options?: Record<string, unknown>);
	addElement(control: VehicleTimeControl): void;
	getNode(): HTMLElement;
	delDOM(): void;
}

declare class EditPeriodMonth implements VehicleTimeControl {
	constructor(id: string, options: { dateFrom: Date; onChange: (month: Date) => void });
	getName(): string;
	getDateFrom(): Date;
}

declare class ButtonCmd implements VehicleTimeControl {
	constructor(id: string, options: { title: string; onClick: () => void; caption?: string; glyph?: string });
	getName(): string;
	setEnabled(enabled: boolean): void;
}

declare class Driver_Controller {
	getPublicMethod(name: string): {
		setFieldValue(field: string, value: Date): void;
		run(options: {
			ok: (response: { getModelData(id: string): Element }) => void;
			fail: (response: unknown, code: number, message: string) => void;
		}): void;
	};
}

declare const DriverWorkTimeReport_View: {
	prototype: { showReport(this: { setTemplateContent(html: string): void }, data: Element): void };
};

declare const WindowPrint: { show(options: { content: string }): void };
declare const DOMHelper: { tableToExcel(table: HTMLTableElement, sheet: string, file: string): void };

class vehicleDriverWorkTime_View extends View {
	private readonly content: HTMLElement;
	private readonly printButton: ButtonCmd;
	private readonly exportButton: ButtonCmd;
	private requestNumber = 0;

	constructor(id: string, options?: Record<string, unknown>) {
		super(id, options);
		this.content = this.getNode().querySelector<HTMLElement>("[data-report-content]")!;
		const now = new Date();
		const month = new EditPeriodMonth(id + ":month_date", {
			dateFrom: new Date(now.getFullYear(), now.getMonth(), 1),
			onChange: (date) => this.buildReport(date)
		});
		this.addElement(month);
		this.addElement(new ButtonCmd(id + ":cmdBuildReport", {
			caption: "Заполнить",
			title: "Построить табель за выбранный месяц",
			onClick: () => this.buildReport(month.getDateFrom())
		}));
		this.printButton = new ButtonCmd(id + ":cmdPrint", {
			title: "Печать таблицы",
			glyph: "glyphicon-print",
			onClick: () => {
				const table = this.content.querySelector("table");
				if (table) {
					WindowPrint.show({ content: table.outerHTML });
				}
			}
		});
		this.exportButton = new ButtonCmd(id + ":cmdExport", {
			title: "Экспорт таблицы в Excel",
			glyph: "glyphicon-save-file",
			onClick: () => {
				const table = this.content.querySelector("table");
				if (table) {
					DOMHelper.tableToExcel(table, "Табель по отгрузкам", "ТабельПоОтгрузкам.xls");
				}
			}
		});
		this.addElement(this.printButton);
		this.addElement(this.exportButton);
		this.buildReport(month.getDateFrom());
	}

	private buildReport(date: Date): void {
		const request = ++this.requestNumber;
		this.printButton.setEnabled(false);
		this.exportButton.setEnabled(false);
		this.content.textContent = "Загрузка…";
		const method = new Driver_Controller().getPublicMethod("vehicleDriverWorkTime");
		method.setFieldValue("month_date", date);
		method.run({
			ok: (response) => {
				if (request !== this.requestNumber) {
					return;
				}
				const data = response.getModelData("WorkTimeReport_Model");
				if (!data.getElementsByTagName("row").length) {
					this.content.textContent = "За выбранный месяц отгрузок нет.";
					return;
				}
				DriverWorkTimeReport_View.prototype.showReport.call(this, data);
			},
			fail: (_response, _code, message) => {
				if (request === this.requestNumber) {
					this.content.textContent = message || "Не удалось загрузить табель.";
				}
			}
		});
	}

	// The existing timesheet renderer supplies its calendar, formatting and totals here.
	setTemplateContent(html: string): void {
		this.content.innerHTML = html;
		const table = this.content.querySelector("table")!;
		table.id = this.getNode().id + ":grid";
		this.printButton.setEnabled(true);
		this.exportButton.setEnabled(true);
	}

	delDOM(): void {
		++this.requestNumber;
		super.delDOM();
	}
}

Object.assign(window, { vehicleDriverWorkTime_View });
