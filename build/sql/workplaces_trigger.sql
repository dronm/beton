-- Trigger: workplaces_after_trigger on workplaces

-- DROP TRIGGER workplaces_after_trigger ON workplaces;

 CREATE TRIGGER workplaces_after_trigger
  AFTER INSERT OR UPDATE
  ON workplaces
  FOR EACH ROW
  EXECUTE PROCEDURE workplaces_process();


