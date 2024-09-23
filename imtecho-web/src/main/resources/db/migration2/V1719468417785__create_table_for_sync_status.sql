CREATE TABLE if not exists system_sync_status_file_upload (
    unique_id TEXT PRIMARY KEY,
    action_date TIMESTAMP NOT NULL,
    status TEXT NOT NULL,
    checksum TEXT,
    token TEXT,
    form_type TEXT,
    file_type TEXT,
    file_name TEXT,
    user_name TEXT,
    parent_status TEXT,
    no_of_attempt INTEGER,
    file_path TEXT,
    member_id INTEGER,
    exception TEXT
);
