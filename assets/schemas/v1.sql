CREATE TABLE assets (
    id VARCHAR PRIMARY KEY,
    asset_url VARCHAR,
    creation_date INTEGER,
    year_month INTEGER
);

CREATE TABLE sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    is_done BOOLEAN,
    current_asset_id VARCHAR,
    year_month INTEGER UNIQUE,

    CONSTRAINT fk_current_asset_id
        FOREIGN KEY (current_asset_id)
        REFERENCES assets(id)
        ON DELETE CASCADE
);

CREATE TABLE session_assets (
    asset_id VARCHAR,
    should_drop BOOLEAN,
    session_id INTEGER,

    CONSTRAINT fk_session_id
        FOREIGN KEY (session_id)
        REFERENCES sessions(session_id)
        ON DELETE CASCADE

    CONSTRAINT fk_asset_id
        FOREIGN KEY (asset_id)
        REFERENCES assets(asset_id)
        ON DELETE CASCADE
);