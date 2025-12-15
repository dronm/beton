BEGIN;

CREATE TABLE audit_log(
    id BIGSERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL, -- or JSONB for composite keys
    operation CHAR(1) NOT NULL,
    changes JSONB, -- Only changed columns: {"column": {"old": value, "new": value}}
    changed_at TIMESTAMPTZ DEFAULT NOW(),
    changed_by TEXT --user name
);

-- Create index for performance
CREATE INDEX idx_audit_log_table_operation ON audit_log(table_name, record_id);
CREATE INDEX idx_audit_log_changed_at ON audit_log(changed_at);

COMMIT;
