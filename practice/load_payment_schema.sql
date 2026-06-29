COPY currencies(code, name, is_active, created_at)
FROM '/var/lib/postgresql/currencies.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);

COPY accounts(id, user_id, currency_code, balance_dec, version, created_at, updated_at)
FROM '/var/lib/postgresql/accounts.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);

COPY fee_rules(id, transaction_type, currency_code, percent_fee, fixed_fee, min_amount, max_amount, is_active, created_at)
FROM '/var/lib/postgresql/fee_rules.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);

COPY exchange_rates(base_code, quote_code, rate, started_at, ended_at, is_active, created_at)
FROM '/var/lib/postgresql/exchange_rates.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);

SELECT * FROM currencies LIMIT 10;
SELECT * FROM accounts LIMIT 10;

\timing on
COPY transactions(account_id, type, amount, currency_code, counter_account_id, counter_amount, exchange_rate, fee_amount, fee_rule_id, status, reason, created_at, processed_at, tx_version)
FROM '/var/lib/postgresql/transactions.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);
\timing off

DELETE FROM transactions;

CREATE INDEX idx_transactions_account ON transactions(account_id);
CREATE INDEX idx_transactions_type ON transactions(type);
CREATE INDEX idx_transactions_status ON transactions(status);

\timing on
COPY transactions(account_id, type, amount, currency_code, counter_account_id, counter_amount, exchange_rate, fee_amount, fee_rule_id, status, reason, created_at, processed_at, tx_version)
FROM '/var/lib/postgresql/transactions.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);
\timing off

SELECT count(*) FROM transactions;
