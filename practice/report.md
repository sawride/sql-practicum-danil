# Отчёт по практикуму SQL

## 1. Установка и настройка дистрибутива

- Установлен Docker Desktop (macOS)
- Установлен pgAdmin 4
- Создан файл `docker-compose.yml` в корне проекта
- Запущен контейнер PostgreSQL командой:

```shell
docker compose up -d
```

- Контейнер `pg_sql_study` успешно запущен (образ postgres:17.10)
- В pgAdmin создан сервер с подключением:
  - Host: 127.0.0.1
  - Port: 5454
  - Database: sql_study_db
  - User: my_user

## 2. Теоретическая часть

### 2.1 Создание таблиц и типы данных

Создана таблица `weather` с использованием базовых типов `varchar`, `int`, `real`, `date`.

![Создание таблицы weather](screenshots/01-create-table.png)

### 2.2 Добавление и выборка данных

Изучены команды `INSERT`, `SELECT`, `WHERE`, `ORDER BY`, `DISTINCT`.

![Данные в таблице weather](screenshots/02-insert-data.png)

### 2.3 Соединения таблиц (JOIN)

Создана таблица `cities`, изучены `INNER JOIN` и `LEFT OUTER JOIN`.

![Результат JOIN](screenshots/03-join.png)

### 2.4 Внешние ключи

Создана связь `weather` → `cities` через `REFERENCES`, проверено срабатывание ошибки при нарушении целостности.

![Ошибка внешнего ключа](screenshots/04-fk-error.png)

### 2.5 Оконные функции

Создана таблица `empsalary`, изучены `PARTITION BY`, `rank()`, `sum() OVER`.

![Оконные функции](screenshots/05-window-functions.png)

### 2.6 Наследование таблиц

Создана структура `cities` / `capitals` с `INHERITS`, изучена работа `ONLY`.

![Наследование](screenshots/06-inheritance.png)

### 2.7 Ограничения (constraints)

Изучены `DEFAULT`, `NOT NULL`, `CHECK`, `UNIQUE`, `PRIMARY KEY` на примере таблицы `products`.

![Ошибка PRIMARY KEY](screenshots/07-pk-error.png)

## 3. Практическая часть на схемах платёжного сервиса

### 3.1 Создание сервера

Создан `docker-compose.yml` в директории `practice` (пользователь `admin`, база `payment_db`, контейнер `psql_payments_container`).
Запущена команда `docker compose up -d`, контейнер `psql_payments_container` успешно запущен.

![Запуск контейнера](screenshots/one.png)

Проверка контейнера через Docker Desktop.

![Контейнер в Docker Desktop](screenshots/two.png)

Лог контейнера `psql_payments_container`.

![Лог контейнера](screenshots/three.png)

Регистрация нового сервера в pgAdmin под пользователем `admin`.

![Регистрация сервера в pgAdmin](screenshots/five.png)

![Подключение под admin](screenshots/six.png)

Список баз данных после подключения.

![Список серверов в pgAdmin](screenshots/seven.png)

### 3.2 Настройка DCL

Созданы пользователи `tech_payments` и `tech_users`. Созданы схемы `payment_schema` и `user_schema`.
Выданы права каждому пользователю только на свою схему.

![Выдача прав GRANT](screenshots/p01-docker-log.png)

Проверка: подключение под `tech_users` и попытка создать таблицу в `payment_schema` — система выдаёт ошибку доступа.

![Ошибка доступа к чужой схеме](screenshots/p02-access-denied.png)

### 3.3 DDL схемы пользователей (user_schema)

Под пользователем `tech_users` создана таблица `users` с полями `id`, `login`, `email`, `phone`, `client_type`, `status`, `created_at`, `updated_at`.

![Создание таблицы users](screenshots/p03-users-table.png)

Также созданы таблицы `user_personal_data`, `individual_profiles`, `legal_entity_profiles`, `foreign_resident_profiles` и индексы `idx_users_email`, `idx_users_login`, `idx_users_client_type`.

![Создание индексов user_schema](screenshots/p04-currencies-type.png)

### 3.4 DDL схемы платежей (payment_schema)

Под пользователем `tech_payments` созданы справочник `currencies`, тип `transaction_type`, таблицы `accounts`, `fee_rules`, `transactions` и `exchange_rates`.

![Создание таблицы exchange_rates](screenshots/p05-payment-schema-tables.png)

### 3.5 Наполнение схем данными

CSV-файлы скачаны из [хранилища](https://disk.yandex.ru/d/78_ar_43nRQ83Q) и скопированы в контейнер:

```shell
docker cp practice/data/sql-course/user_schema/. psql_payments_container:/var/lib/postgresql/
docker cp practice/data/sql-course/payment_schema/. psql_payments_container:/var/lib/postgresql/
```

Под `admin` выданы права `pg_read_server_files` пользователям `tech_payments` и `tech_users`.
Данные загружены командой `COPY FROM` под соответствующими пользователями.

![Выборка users](screenshots/p06-users-data.png)

![Выборка currencies](screenshots/p07-currencies-data.png)

Для таблицы `transactions` замерено время вставки без индексов и с индексами — вставка с индексами выполняется дольше.
