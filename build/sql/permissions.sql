/*
CREATE TABLE permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER TO ;
*/
/*
INSERT INTO permissions VALUES (
	'{"admin":{
		"User":{
			"insert":true,"delete":true,"update":true,"get_object":true,"get_list":true
			,"get_profile":true, "get_excel_file":true
		},
		"Event":{
			"subscribe":true, "unsubscribe":true, "publish":true
		},
		"Constant":{
			"get_list":true, "get_object":true, "get_values":true, "set_value":true
		}
		}
	}'
);
*/

update permissions set rules = 
	'{"admin":{
		"User":{
			"insert":true,"delete":true,"update":true,"get_object":true,"get_list":true
			,"get_profile":true, "get_excel_file":true
		},
		"Event":{
			"subscribe":true, "unsubscribe":true, "publish":true
		},
		"Constant":{
			"get_list":true, "get_object":true, "get_values":true, "set_value":true
		}
	},
	"guest":{
		"User":{
			"insert":true,"delete":true,"update":true,"get_object":true,"get_list":true
			,"get_profile":true, "get_excel_file":true
		},
		"Event":{
			"subscribe":true, "unsubscribe":true, "publish":true
		},
		"Constant":{
			"get_list":true, "get_object":true, "get_values":true, "set_value":true
		}
	}	
	}'
;

