CREATE USER tech_payments WITH PASSWORD 'tech_psw1';
CREATE USER tech_users WITH PASSWORD 'tech_psw2';

CREATE SCHEMA payment_schema AUTHORIZATION tech_payments;
CREATE SCHEMA user_schema AUTHORIZATION tech_users;

DROP SCHEMA public CASCADE;

GRANT ALL ON SCHEMA payment_schema TO tech_payments;
GRANT ALL ON SCHEMA user_schema TO tech_users;

GRANT CREATE ON SCHEMA payment_schema TO tech_payments;
GRANT CREATE ON SCHEMA user_schema TO tech_users;

ALTER DEFAULT PRIVILEGES IN SCHEMA payment_schema
    GRANT ALL ON TABLES TO tech_payments;
ALTER DEFAULT PRIVILEGES IN SCHEMA user_schema
    GRANT ALL ON TABLES TO tech_users;

ALTER USER tech_payments SET search_path TO payment_schema;
ALTER USER tech_users SET search_path TO user_schema;

GRANT USAGE ON SCHEMA user_schema TO tech_payments;
GRANT REFERENCES ON ALL TABLES IN SCHEMA user_schema TO tech_payments;
ALTER DEFAULT PRIVILEGES IN SCHEMA user_schema
    GRANT REFERENCES ON TABLES TO tech_payments;

GRANT pg_read_server_files TO tech_payments;
GRANT pg_read_server_files TO tech_users;
