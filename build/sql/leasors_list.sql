-- View: public.leasors_list

-- DROP VIEW public.leasors_list;
 
CREATE OR REPLACE VIEW public.leasors_list AS 
	SELECT DISTINCT
		leasor
	FROM vehicles
	WHERE leasor is not null	
	ORDER BY leasor
	;

ALTER TABLE public.leasors_list
  OWNER TO ;

