COPY users(id, login, email, phone, client_type, status, created_at, updated_at)
FROM '/var/lib/postgresql/users.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);

COPY user_personal_data(user_id, encrypted_data, cipher_algo, iv, tag, updated_at, updated_by)
FROM '/var/lib/postgresql/user_personal_data.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);

COPY individual_profiles(user_id, first_name, last_name, middle_name, birth_date, country_code, residence_country_code)
FROM '/var/lib/postgresql/individual_profiles.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);

COPY legal_entity_profiles(user_id, company_name, inn, kpp, ogrn, legal_address, actual_address, bank_account, bic)
FROM '/var/lib/postgresql/legal_entity_profiles.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);

COPY foreign_resident_profiles(user_id, foreign_identifier, home_country_code, residence_proof_doc_type, residence_proof_number)
FROM '/var/lib/postgresql/foreign_resident_profiles.csv'
WITH (FORMAT csv, DELIMITER E'\t', NULL '\\N', HEADER false);

SELECT * FROM users LIMIT 10;
SELECT * FROM individual_profiles LIMIT 5;
