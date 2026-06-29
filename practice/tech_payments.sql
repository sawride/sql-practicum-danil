CREATE TABLE currencies (
    code       CHAR(3) PRIMARY KEY,
    name       VARCHAR(100) NOT NULL CHECK (name <> ''),
    is_active  BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
    id            BIGSERIAL PRIMARY KEY,
    user_id       BIGINT NOT NULL,
    currency_code CHAR(3) NOT NULL REFERENCES currencies(code),
    balance_dec   NUMERIC(18, 2) NOT NULL DEFAULT 0,
    version       INTEGER NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_accounts_user_currency UNIQUE (user_id, currency_code)
);

ALTER TABLE accounts
    ADD CONSTRAINT fk_accounts_user
    FOREIGN KEY (user_id) REFERENCES user_schema.users(id);

CREATE TYPE transaction_type AS ENUM (
    'DEPOSIT',
    'WITHDRAWAL',
    'TRANSFER',
    'FEE',
    'EXCHANGE'
);

CREATE TABLE fee_rules (
    id               BIGSERIAL PRIMARY KEY,
    transaction_type transaction_type NOT NULL,
    currency_code    CHAR(3) NOT NULL REFERENCES currencies(code),
    percent_fee      NUMERIC(5, 2) NOT NULL DEFAULT 0,
    fixed_fee        NUMERIC(18, 2) NOT NULL DEFAULT 0,
    min_amount       NUMERIC(18, 2),
    max_amount       NUMERIC(18, 2),
    is_active        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transactions (
    id                 BIGSERIAL PRIMARY KEY,
    account_id         BIGINT NOT NULL REFERENCES accounts(id),
    type               transaction_type NOT NULL,
    amount             NUMERIC(18, 2) NOT NULL CHECK (amount >= 0),
    currency_code      CHAR(3) NOT NULL REFERENCES currencies(code),
    counter_account_id BIGINT REFERENCES accounts(id),
    counter_amount     NUMERIC(18, 2),
    exchange_rate      NUMERIC(18, 6),
    fee_amount         NUMERIC(18, 2) CHECK (fee_amount IS NULL OR fee_amount >= 0),
    fee_rule_id        BIGINT REFERENCES fee_rules(id),
    status             VARCHAR(16) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING', 'CONFIRMED', 'FAILED', 'REVERSED')),
    reason             TEXT,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_at       TIMESTAMPTZ,
    tx_version         INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE exchange_rates (
    id          BIGSERIAL PRIMARY KEY,
    base_code   CHAR(3) NOT NULL REFERENCES currencies(code),
    quote_code  CHAR(3) NOT NULL REFERENCES currencies(code),
    rate        NUMERIC(18, 6) NOT NULL,
    started_at  TIMESTAMPTZ NOT NULL,
    ended_at    TIMESTAMPTZ,
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
