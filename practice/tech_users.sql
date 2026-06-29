CREATE TYPE client_type AS ENUM (
    'INDIVIDUAL',
    'LEGAL_ENTITY',
    'FOREIGN_RESIDENT'
);

CREATE TYPE user_status AS ENUM (
    'INACTIVE',
    'ACTIVE',
    'BLOCKED'
);

CREATE TABLE users (
    id          BIGSERIAL PRIMARY KEY,
    login       VARCHAR(64) NOT NULL UNIQUE,
    email       VARCHAR(255) NOT NULL,
    phone       VARCHAR(32),
    client_type client_type NOT NULL DEFAULT 'INDIVIDUAL',
    status      user_status NOT NULL DEFAULT 'INACTIVE',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_users_client_type CHECK (
        client_type IN ('INDIVIDUAL', 'LEGAL_ENTITY', 'FOREIGN_RESIDENT')
    ),
    CONSTRAINT chk_users_status CHECK (
        status IN ('INACTIVE', 'ACTIVE', 'BLOCKED')
    )
);

CREATE TABLE user_personal_data (
    user_id        BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    encrypted_data BYTEA NOT NULL,
    cipher_algo    VARCHAR(64) NOT NULL DEFAULT 'AES-256-GCM',
    iv             BYTEA NOT NULL,
    tag            BYTEA NOT NULL,
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by     VARCHAR(64) NOT NULL
);

CREATE TABLE individual_profiles (
    user_id                BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    first_name             VARCHAR(100) NOT NULL,
    last_name              VARCHAR(100) NOT NULL,
    middle_name            VARCHAR(100),
    birth_date             DATE,
    country_code           CHAR(2) NOT NULL,
    residence_country_code CHAR(2) NOT NULL
);

CREATE TABLE legal_entity_profiles (
    user_id        BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    company_name   VARCHAR(255) NOT NULL CHECK (company_name <> ''),
    inn            VARCHAR(12),
    kpp            VARCHAR(9),
    ogrn           VARCHAR(15),
    legal_address  TEXT,
    actual_address TEXT,
    bank_account   VARCHAR(20),
    bic            VARCHAR(9)
);

CREATE TABLE foreign_resident_profiles (
    user_id                  BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    foreign_identifier       VARCHAR(64) NOT NULL,
    home_country_code        CHAR(2) NOT NULL,
    residence_proof_doc_type TEXT,
    residence_proof_number   TEXT
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_login ON users(login);
CREATE INDEX idx_users_client_type ON users(client_type);
