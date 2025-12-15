-- Add trigger to specific table
/*
--suppliers
CREATE TRIGGER audit_log_suppliers
AFTER INSERT OR UPDATE OR DELETE ON suppliers
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--clients
CREATE TRIGGER audit_log_clients
AFTER INSERT OR UPDATE OR DELETE ON clients
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

*/

--users
CREATE TRIGGER audit_log_users
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--destinations
CREATE TRIGGER audit_log_destinations
AFTER INSERT OR UPDATE OR DELETE ON destinations
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--concrete_types
CREATE TRIGGER audit_log_concrete_types
AFTER INSERT OR UPDATE OR DELETE ON concrete_types
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--vehicle_owners
CREATE TRIGGER audit_log_vehicle_owner
AFTER INSERT OR UPDATE OR DELETE ON vehicle_owners
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--vehicles
CREATE TRIGGER audit_log_vehicles
AFTER INSERT OR UPDATE OR DELETE ON vehicles
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--pump_vehicles
CREATE TRIGGER audit_log_pump_vehicles
AFTER INSERT OR UPDATE OR DELETE ON pump_vehicles
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--employees
CREATE TRIGGER audit_log_pump_employees
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--concrete_costs_h
CREATE TRIGGER audit_log_concrete_costs_h
AFTER INSERT OR UPDATE OR DELETE ON concrete_costs_h
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--concrete_costs
CREATE TRIGGER audit_log_concrete_costs
AFTER INSERT OR UPDATE OR DELETE ON concrete_costs
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--shipment_for_owner_costs_h
CREATE TRIGGER audit_log_shipment_for_owner_costs_h
AFTER INSERT OR UPDATE OR DELETE ON shipment_for_owner_costs_h
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--shipment_for_owner_costs
CREATE TRIGGER audit_log_shipment_for_owner_costs
AFTER INSERT OR UPDATE OR DELETE ON shipment_for_owner_costs
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--raw_material_cons_rates
CREATE TRIGGER audit_log_raw_material_cons_rates
AFTER INSERT OR UPDATE OR DELETE ON raw_material_cons_rates
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--orders
CREATE TRIGGER audit_log_orders
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--shipments
CREATE TRIGGER audit_log_shipments
AFTER INSERT OR UPDATE OR DELETE ON shipments
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--doc_material_procurements
CREATE TRIGGER audit_log_doc_material_procurements
AFTER INSERT OR UPDATE OR DELETE ON doc_material_procurements
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--doc_material_movements
CREATE TRIGGER audit_log_doc_material_movements
AFTER INSERT OR UPDATE OR DELETE ON doc_material_movements
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--cement_silo_balance_resets
CREATE TRIGGER audit_log_cement_silo_balance_resets
AFTER INSERT OR UPDATE OR DELETE ON cement_silo_balance_resets
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

--material_fact_consumption_corrections
CREATE TRIGGER audit_log_material_fact_consumption_corrections
AFTER INSERT OR UPDATE OR DELETE ON material_fact_consumption_corrections
FOR EACH ROW EXECUTE FUNCTION audit_log_process();

