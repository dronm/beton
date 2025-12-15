-- Enable session variables (available in all PostgreSQL versions)
CREATE OR REPLACE FUNCTION set_session_var(name text, value text) RETURNS void AS $$
BEGIN
    EXECUTE 'SET LOCAL ' || quote_ident(name) || ' = ' || quote_literal(value);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
