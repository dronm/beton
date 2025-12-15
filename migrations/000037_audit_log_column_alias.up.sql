begin;

-- Simple table for column aliases
CREATE TABLE audit_column_aliases (
    id SERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    column_name TEXT NOT NULL,
    column_alias TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(table_name, column_name)
);

-- Create index for performance
CREATE INDEX idx_audit_column_aliases_lookup 
ON audit_column_aliases(table_name, column_name) 
WHERE is_active = TRUE;

-- Add some sample aliases
INSERT INTO audit_column_aliases (table_name, column_name, column_alias) VALUES
('suppliers', 'name', 'Наименование'),
('suppliers', 'name_full', 'Полное Наименоание');

commit;
