CREATE TABLE sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    current_asset_id VARCHAR,
    asset_ids_to_drop BLOB,
    year_month INTEGER UNIQUE,

    CONSTRAINT fk_current_asset_id
        FOREIGN KEY (current_asset_id)
        REFERENCES assets(id)
        ON DELETE CASCADE
);
