
## CREATE ROLE

```postgres-sql
CREATE ROLE имя [ [ WITH ] параметр [ ... ] ]
```

Здесь параметр:
```postgres-sql
SUPERUSER | NOSUPERUSER | CREATEDB | NOCREATEDB | CREATEROLE | NOCREATEROLE
| INHERIT | NOINHERIT | LOGIN | NOLOGIN | REPLICATION | NOREPLICATION
| BYPASSRLS | NOBYPASSRLS | CONNECTION LIMIT предел_подключений
| [ ENCRYPTED ] PASSWORD 'пароль' | PASSWORD NULL
| VALID UNTIL 'дата_время'
| IN ROLE имя_роли [, ...]
| IN GROUP имя_роли [, ...]
| ROLE имя_роли [, ...]
| ADMIN имя_роли [, ...]
| USER имя_роли [, ...]
| SYSID uid
```

### Описание

`CREATE ROLE` добавляет новую роль в кластер баз данных PostgreSQL. 

Роль — это сущность, которая может владеть объектами и иметь определённые права в базе; 
роль может представлять «пользователя», «группу» или и то, и другое, в зависимости от варианта использования. 

Чтобы выполнить эту команду, необходимо быть суперпользователем или иметь право **CREATEROLE**.

Учтите, что роли определяются на уровне кластера баз данных, так что они действуют во всех базах в кластере.

Во время создания роли можно сразу назначить создаваемую роль членом существующей роли, 
а также назначить существующие роли членами создаваемой роли. 

Правила, по которым включаются начальные параметры членства в роли, описаны ниже в предложениях **IN ROLE**, **ROLE** и **ADMIN**.

Команда [GRANT](#grant) позволяет управлять назначением членов ролей и даёт возможность изменять эти параметры после создания новой роли.

### Примечания

Для изменения атрибутов роли применяется `ALTER ROLE`, а для удаления роли — `DROP ROLE`. 
Всеатрибуты, заданные в `CREATE ROLE`, могут быть изменены позднее командами `ALTER ROLE`.

---

## CREATE TABLE

**_CREATE TABLE_** — создать таблицу

### Синтаксис

```postgres-sql
CREATE [ [ GLOBAL | LOCAL ] { TEMPORARY | TEMP } | UNLOGGED ] TABLE [ IF NOT EXISTS ] имя_таблицы ( 
[ 
    { имя_столбца тип_данных [ STORAGE { PLAIN | EXTERNAL | EXTENDED | MAIN | DEFAULT } ]
    [ COMPRESSION метод_сжатия ] [ COLLATE правило_сортировки ] [ ограничение_столбца [ ... ] ]
    | ограничение_таблицы
    | LIKE таблица_источник [ параметр_LIKE ... ] 
    } [, ... ] 
]
) [ INHERITS ( таблица_родитель [, ... ] ) ]
[ PARTITION BY { RANGE | LIST | HASH } ( { имя_столбца | ( выражение ) }
[ COLLATE правило_сортировки ] [ класс_операторов ] [, ... ] ) ]
[ USING метод ] [ WITH ( параметр_хранения [= значение] [, ... ] ) | WITHOUT OIDS ]
[ ON COMMIT { PRESERVE ROWS | DELETE ROWS | DROP } ]
[ TABLESPACE табл_пространство ]
```

```postgres-sql
CREATE [ [ GLOBAL | LOCAL ] { TEMPORARY | TEMP } | UNLOGGED ] TABLE [ IF NOT EXISTS ] имя_таблицы 
OF имя_типа [ ( 
    { имя_столбца [ WITH OPTIONS ] [ ограничение_столбца [ ... ] ] | ограничение_таблицы } [, ... ] 
) ]
[ PARTITION BY { RANGE | LIST | HASH } ( { имя_столбца | ( выражение ) }
[ COLLATE правило_сортировки ] [ класс_операторов ] [, ... ] ) ]
[ USING метод ]
[ WITH ( параметр_хранения [= значение] [, ... ] ) | WITHOUT OIDS ]
[ ON COMMIT { PRESERVE ROWS | DELETE ROWS | DROP } ]
[ TABLESPACE табл_пространство ]
```

```postgres-sql
CREATE [ [ GLOBAL | LOCAL ] { TEMPORARY | TEMP } | UNLOGGED ] TABLE [ IF NOT EXISTS ] имя_таблицы
PARTITION OF таблица_родитель [ (
    { имя_столбца [ WITH OPTIONS ] [ ограничение_столбца [ ... ] ] | ограничение_таблицы } [, ... ]
) ] { FOR VALUES указание_границ_секции | DEFAULT }
[ PARTITION BY { RANGE | LIST | HASH } ( { имя_столбца | ( выражение ) }
[ COLLATE правило_сортировки ] [ класс_операторов ] [, ... ] ) ]
[ USING метод ]
[ WITH ( параметр_хранения [= значение] [, ... ] ) | WITHOUT OIDS ]
[ ON COMMIT { PRESERVE ROWS | DELETE ROWS | DROP } ]
[ TABLESPACE табл_пространство ]
```

Здесь `ограничение_столбца`:
```postgres-sql
[ CONSTRAINT имя_ограничения ]
{ 
    NOT NULL | NULL | CHECK ( выражение ) [ NO INHERIT ] | 
    DEFAULT выражение_по_умолчанию |
    GENERATED ALWAYS AS ( генерирующее_выражение ) STORED | 
    GENERATED { ALWAYS | BY DEFAULT } AS IDENTITY [ ( параметры_последовательности ) ] | 
    UNIQUE [ NULLS [ NOT ] DISTINCT ] параметры_индекса | 
    PRIMARY KEY параметры_индекса | 
    REFERENCES целевая_таблица [ ( целевой_столбец ) ] [ MATCH FULL | MATCH PARTIAL |  MATCH SIMPLE ]
    [ ON DELETE ссылочное_действие ] [ ON UPDATE ссылочное_действие ] 
}
[ DEFERRABLE | NOT DEFERRABLE ] 
[ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]
```

и `ограничение_таблицы`:
```postgres-sql
[ CONSTRAINT имя_ограничения ]
{ 
    CHECK ( выражение ) [ NO INHERIT ] | UNIQUE [ NULLS [ NOT ] DISTINCT ] ( имя_столбца [, ... ] ) параметры_индекса |
    PRIMARY KEY ( имя_столбца [, ... ] ) параметры_индекса |
    EXCLUDE [ USING индексный_метод ] ( элемент_исключения WITH оператор [, ... ] ) параметры_индекса [ WHERE ( предикат ) ] |
    FOREIGN KEY ( имя_столбца [, ... ] ) REFERENCES целевая_таблица [ ( целевой_столбец [, ... ] ) ]
    [ MATCH FULL | MATCH PARTIAL | MATCH SIMPLE ] [ ON DELETE ссылочное_действие ] [ ON UPDATE ссылочное_действие ] 
}
[ DEFERRABLE | NOT DEFERRABLE ] [ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]
```

и `параметр_LIKE`:
```postgres-sql
{ INCLUDING | EXCLUDING } 
{ COMMENTS | COMPRESSION | CONSTRAINTS | DEFAULTS | GENERATED | IDENTITY | INDEXES | STATISTICS | STORAGE | ALL }
```

и `указание_границ_секции`:
```postgres-sql
IN ( выражение_границ_секции [, ...] ) |
FROM ( { выражение_границ_секции | MINVALUE | MAXVALUE } [, ...] )
  TO ( { выражение_границ_секции | MINVALUE | MAXVALUE } [, ...] ) |
WITH ( MODULUS числовая_константа, REMAINDER числовая_константа )
```

`параметры_индекса` в ограничениях UNIQUE, PRIMARY KEY и EXCLUDE:
```postgres-sql
[ INCLUDE ( имя_столбца [, ... ] ) ]
[ WITH ( параметр_хранения [= значение] [, ... ] ) ]
[ USING INDEX TABLESPACE табл_пространство ]
```

`элемент_исключения` в ограничении EXCLUDE:
```postgres-sql
{ имя_столбца | ( выражение ) } [ COLLATE правило_сортировки ] 
[ класс_операторов [ ( параметр_класса_оп = значение [, ... ] ) ] ] 
[ ASC | DESC ] 
[ NULLS { FIRST |  LAST } ]
```

`ссылочное_действие` в ограничении FOREIGN KEY/REFERENCES:
```postgres-sql
{ 
    NO ACTION | RESTRICT | CASCADE | SET NULL [ ( имя_столбца [, ... ] ) ] | 
    SET DEFAULT [ ( имя_столбца [, ... ] ) ] 
}
```

---

## ALTER TABLE
```postgres-psql
ALTER TABLE [ IF EXISTS ] [ ONLY ] имя [ * ] действие [, ... ]
```
```postgres-psql
ALTER TABLE [ IF EXISTS ] [ ONLY ] имя [ * ] RENAME [ COLUMN ] имя_столбца TO новое_имя_столбца
```
```postgres-psql
ALTER TABLE [ IF EXISTS ] [ ONLY ] имя [ * ]
RENAME CONSTRAINT имя_ограничения TO имя_нового_ограничения
```
```postgres-psql
ALTER TABLE [ IF EXISTS ] имя RENAME TO новое_имя
```
```postgres-psql
ALTER TABLE [ IF EXISTS ] имя SET SCHEMA новая_схема
```
```postgres-psql
ALTER TABLE ALL IN TABLESPACE имя [ OWNED BY имя_роли [, ... ] ]
SET TABLESPACE новое_табл_пространство [ NOWAIT ]
```

Добавить секцию в секционированную таблицу
```postgres-psql
ALTER TABLE [ IF EXISTS ] имя
ATTACH PARTITION имя_секции { FOR VALUES указание_границ_секции | DEFAULT }
```

Удалить секцию из секционированной таблицы
```postgres-psql
ALTER TABLE [ IF EXISTS ] имя
DETACH PARTITION имя_секции [ CONCURRENTLY | FINALIZE ]
```

Где действие может быть следующим:
```postgres-psql
ADD [ COLUMN ] [ IF NOT EXISTS ] имя_столбца тип_данных [ COLLATE правило_сортировки ] [ ограничение_столбца [ ... ] ]

DROP [ COLUMN ] [ IF EXISTS ] имя_столбца [ RESTRICT | CASCADE ]

ALTER [ COLUMN ] имя_столбца [ SET DATA ] TYPE тип_данных
[ COLLATE правило_сортировки ] [ USING выражение ]

ALTER [ COLUMN ] имя_столбца { SET | DROP }  DEFAULT выражение

ALTER [ COLUMN ] имя_столбца { SET | DROP } NOT NULL

ALTER [ COLUMN ] имя_столбца DROP EXPRESSION [ IF EXISTS ]

ALTER [ COLUMN ] имя_столбца ADD GENERATED { ALWAYS | BY DEFAULT } AS IDENTITY [ ( параметры_последовательности ) ]

ALTER [ COLUMN ] имя_столбца 
{ SET GENERATED { ALWAYS | BY DEFAULT } | SET параметр_последовательности | RESTART [ [ WITH ] перезапуск ] } [...]

ALTER [ COLUMN ] имя_столбца DROP IDENTITY [ IF EXISTS ]

ALTER [ COLUMN ] имя_столбца SET STATISTICS integer

ALTER [ COLUMN ] имя_столбца SET ( атрибут = значение [, ... ] )

ALTER [ COLUMN ] имя_столбца RESET ( атрибут [, ... ] )

ALTER [ COLUMN ] имя_столбца SET STORAGE { PLAIN | EXTERNAL | EXTENDED | MAIN | DEFAULT }

ALTER [ COLUMN ] имя_столбца SET COMPRESSION метод_сжатия

ADD ограничение_таблицы [ NOT VALID ]
ADD ограничение_таблицы_по_индексу ALTER CONSTRAINT имя_ограничения [ DEFERRABLE | NOT DEFERRABLE ] 
[ INITIALLY DEFERRED | INITIALLY IMMEDIATE ]

VALIDATE CONSTRAINT имя_ограничения

DROP CONSTRAINT [ IF EXISTS ]  имя_ограничения [ RESTRICT | CASCADE ]

DISABLE TRIGGER [ имя_триггера | ALL | USER ]

ENABLE TRIGGER [ имя_триггера | ALL | USER ]

ENABLE REPLICA TRIGGER имя_триггера

ENABLE ALWAYS TRIGGER имя_триггера

DISABLE RULE имя_правила_перезаписи

ENABLE RULE имя_правила_перезаписи

ENABLE REPLICA RULE имя_правила_перезаписи

ENABLE ALWAYS RULE имя_правила_перезаписи

DISABLE ROW LEVEL SECURITY

ENABLE ROW LEVEL SECURITY

FORCE ROW LEVEL SECURITY

NO FORCE ROW LEVEL SECURITY

CLUSTER ON имя_индекса

SET WITHOUT CLUSTER

SET WITHOUT OIDS

SET ACCESS METHOD новый_метод_доступа

SET TABLESPACE новое_табл_пространство

SET { LOGGED | UNLOGGED }

SET ( параметр_хранения [= значение] [, ... ] )

RESET ( параметр_хранения [, ... ] )

INHERIT таблица_родитель

NO INHERIT таблица_родитель

OF имя_типа

NOT OF

OWNER TO { новый_владелец | CURRENT_ROLE | CURRENT_USER | SESSION_USER }

REPLICA IDENTITY { DEFAULT | USING INDEX имя_индекса | FULL | NOTHING }
```

---

## CREATE TABLESPACE

**_CREATE TABLESPACE_** — создать табличное пространство

### Синтаксис
```postgres-sql
CREATE TABLESPACE табл_пространство
[ OWNER { новый_владелец | CURRENT_ROLE | CURRENT_USER | SESSION_USER } ]
LOCATION 'directory'
[ WITH ( параметр_табличного_пространства = значение [, ... ] ) ]
```

### Описание

**CREATE TABLESPACE** регистрирует новое табличное пространство на уровне кластера баз данных.
Имя табличного пространства должно отличаться от имён уже существующих табличных пространств в кластере.

Табличные пространства позволяют суперпользователям определять альтернативные расположения в файловой системе, 
где могут находиться файлы, содержащие объекты базы данных (например, таблицы или индексы).

Пользователь, имеющий соответствующие права, может передать параметр `табл_пространство` команде 
`CREATE DATABASE`, `CREATE TABLE`, `CREATE INDEX` или `ADD CONSTRAINT`, 
чтобы файлы данных для этих объектов хранились в указанном табличном пространстве.

### Параметры

* `табл_пространство`
    - Имя создаваемого табличного пространства. Это имя не может начинаться с `pg_`, 
    так как такие имена зарезервированы для системных табличных пространств.
  
* `имя_пользователя`
  - Имя пользователя, который будет владельцем табличного пространства. 
  Если опущено, владельцем по умолчанию станет пользователь, выполняющий команду. 
  Создавать табличные пространства могут только суперпользователи, 
  но их владельцами могут быть назначены и обычные пользователи.
* `directory`
  - Каталог, который будет использован для этого табличного пространства. 
  Этот каталог должен уже существовать (`CREATE TABLESPACE` не создаст его), 
  быть пустым и принадлежать системному пользователю PostgreSQL. 
  Задаваться его расположение должно абсолютным путём. 
* `параметр_табличного_пространства`
  - Устанавливаемый или сбрасываемый параметр табличного пространства. 
  В настоящее время поддерживаются только параметры 
    + `seq_page_cost`, 
    + `random_page_cost`, 
    + `effective_io_concurrency` и 
    + `maintenance_io_concurrency`. 
  При установке этих значений для заданного табличного пространства переопределяются обычная оценка стоимости чтения
  страниц из таблиц в этом пространстве и характеристики предвыборки во время выполнения, 
  зависящие от одноимённых параметров конфигурации. Это может быть полезно, 
  если одно из табличных пространств размещено на диске, который быстрее или медленнее остальной дисковой подсистемы.


---

## GRANT

**_GRANT_** — определить права доступа

### Синтаксис

```postgres-sql
GRANT { { SELECT | INSERT | UPDATE | DELETE | TRUNCATE | REFERENCES | TRIGGER }
[, ...] | ALL [ PRIVILEGES ] } ON { [ TABLE ] имя_таблицы [, ...] | ALL TABLES IN SCHEMA имя_схемы [, ...] }
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { { SELECT | INSERT | UPDATE | REFERENCES } ( имя_столбца [, ...] ) 
[, ...] | ALL [ PRIVILEGES ] ( имя_столбца [, ...] ) } ON [ TABLE ] имя_таблицы [, ...]
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { { USAGE | SELECT | UPDATE } [, ...] | ALL [ PRIVILEGES ] }
ON { SEQUENCE имя_последовательности [, ...] | ALL SEQUENCES IN SCHEMA имя_схемы [, ...] }
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { { CREATE | CONNECT | TEMPORARY | TEMP } [, ...] | ALL [ PRIVILEGES ] }
ON DATABASE имя_бд [, ...] TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { USAGE | ALL [ PRIVILEGES ] } ON DOMAIN имя_домена [, ...]
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { USAGE | ALL [ PRIVILEGES ] } ON FOREIGN DATA WRAPPER имя_обёртки_сторонних_данных [, ...]
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { USAGE | ALL [ PRIVILEGES ] } ON FOREIGN SERVER имя_сервера [, ...]
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { EXECUTE | ALL [ PRIVILEGES ] }
ON { { FUNCTION | PROCEDURE | ROUTINE } имя_подпрограммы [ ( [ [ режим_аргумента ] [ имя_аргумента ] тип_аргумента [, ...] ] ) ] [, ...]
 | ALL { FUNCTIONS | PROCEDURES | ROUTINES } IN SCHEMA имя_схемы [, ...] }
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { USAGE | ALL [ PRIVILEGES ] } ON LANGUAGE имя_языка [, ...]
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { { SELECT | UPDATE } [, ...] | ALL [ PRIVILEGES ] }
ON LARGE OBJECT oid_БО [, ...] TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { { SET | ALTER SYSTEM } [, ... ] | ALL [ PRIVILEGES ] }
ON PARAMETER параметр_конфигурации [, ...] TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { { CREATE | USAGE } [, ...] | ALL [ PRIVILEGES ] } ON SCHEMA имя_схемы [, ...]
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { CREATE | ALL [ PRIVILEGES ] } ON TABLESPACE табл_пространство [, ...]
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```
```postgres-sql
GRANT { USAGE | ALL [ PRIVILEGES ] } ON TYPE имя_типа [, ...]
TO указание_роли [, ...] [ WITH GRANT OPTION ] [ GRANTED BY указание_роли ];
```

```postgres-sql
GRANT имя_роли [, ...] TO указание_роли [, ...]
[ WITH { ADMIN | INHERIT | SET } { OPTION | TRUE | FALSE } ] [ GRANTED BY указание_роли ];
```
Здесь указание_роли:
```postgres-sql
[ GROUP ] имя_роли | PUBLIC | CURRENT_ROLE | CURRENT_USER | SESSION_USER
```

### Описание

Команда `GRANT` имеет две основные разновидности: 
* первая назначает права для доступа к объектам баз данных 
(таблицам, столбцам, представлениям, сторонним таблицам, последовательностям, базам данных, обёрткам сторонних данных, 
сторонним серверам, функциям, процедурам, процедурным языкам, большим объектам, параметрам конфигурации, 
схемам, табличным пространствамили типам), 
* вторая назначает одни роли членами других. 

Эти разновидности во многом похожи, но имеют достаточно отличий, чтобы рассматривать их отдельно.

---

# REVOKE

REVOKE — отозвать права доступа

### Синтаксис

```postgres-sql
REVOKE [ GRANT OPTION FOR ]
{ { SELECT | INSERT | UPDATE | DELETE | TRUNCATE | REFERENCES | TRIGGER } [, ...] | ALL [ PRIVILEGES ] }
ON { [ TABLE ] имя_таблицы [, ...] | ALL TABLES IN SCHEMA имя_схемы [, ...] }
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ]
{ { SELECT | INSERT | UPDATE | REFERENCES } ( имя_столбца [, ...] ) [, ...] | ALL [ PRIVILEGES ] ( имя_столбца [, ...] ) }
ON [ TABLE ] имя_таблицы [, ...] FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { { USAGE | SELECT | UPDATE } [, ...] | ALL [ PRIVILEGES ] }
ON { SEQUENCE имя_последовательности [, ...] | ALL SEQUENCES IN SCHEMA имя_схемы [, ...] }
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ]
{ { CREATE | CONNECT | TEMPORARY | TEMP } [, ...] | ALL [ PRIVILEGES ] } ON DATABASE имя_бд [, ...]
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { USAGE | ALL [ PRIVILEGES ] } ON DOMAIN имя_домена [, ...]
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { USAGE | ALL [ PRIVILEGES ] }
ON FOREIGN DATA WRAPPER имя_обёртки_сторонних_данных [, ...]
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ]
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { USAGE | ALL [ PRIVILEGES ] }
ON FOREIGN SERVER имя_сервера [, ...]
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { EXECUTE | ALL [ PRIVILEGES ] }
ON { { FUNCTION | PROCEDURE | ROUTINE } имя_функции [ ( [ [ режим_аргумента ]
[ имя_аргумента ] тип_аргумента [, ...] ] ) ] [, ...] | ALL { FUNCTIONS | PROCEDURES | ROUTINES } 
IN SCHEMA имя_схемы [, ...] }
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { USAGE | ALL [ PRIVILEGES ] }
ON LANGUAGE имя_языка [, ...]
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { { SELECT | UPDATE } [, ...] | ALL [ PRIVILEGES ] }
ON LARGE OBJECT oid_БО [, ...]
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { { SET | ALTER SYSTEM } [, ...] | ALL [ PRIVILEGES ] }
ON PARAMETER параметр_конфигурации [, ...]
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { { CREATE | USAGE } [, ...] | ALL [ PRIVILEGES ] }
ON SCHEMA имя_схемы [, ...]
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { CREATE | ALL [ PRIVILEGES ] }
ON TABLESPACE табл_пространство [, ...]
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ GRANT OPTION FOR ] { USAGE | ALL [ PRIVILEGES ] }
ON TYPE имя_типа [, ...]
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
```postgres-sql
REVOKE [ { ADMIN | INHERIT | SET } OPTION FOR ] имя_роли [, ...] 
FROM указание_роли [, ...] [ GRANTED BY указание_роли ] [ CASCADE | RESTRICT ];
```
Здесь указание_роли:
```postgres-sql
[ GROUP ] имя_роли | PUBLIC | CURRENT_ROLE | CURRENT_USER | SESSION_USER
```

### Описание

Команда `REVOKE` лишает одну или несколько ролей прав, назначенных ранее. 

Ключевое слово `PUBLIC` обозначает неявно определённую группу всех ролей.

Заметьте, что любая конкретная роль получает в сумме права, данные непосредственно ей, 
права, данные любой роли, в которую она включена, а также права, данные группе `PUBLIC`. 
Поэтому, например, лишение `PUBLIC` права `SELECT` не обязательно будет означать, 
что все роли лишатся права `SELECT` для данного объекта: 
оно сохранится у тех ролей, которым оно дано непосредственно или косвенно, через другую роль. 

Подобным образом, лишение права `SELECT` какого-либо пользователя может не повлиять на его возможность пользоваться правом `SELECT`, 
если это право дано группе `PUBLIC` или другой роли, в которую он включён.

Если указано `GRANT OPTION FOR`, отзывается только право передачи права, но не само право. 
Без этого указания отзывается и право, и право распоряжаться им.

Если пользователь обладает правом с правом передачи и он дал его другим пользователям, последнее право считается зависимым. 
Когда первый пользователь лишается самого права или права передачи и существуют зависимые права, 
эти зависимые права также отзываются, если дополнительно указано `CASCADE`; 
в противном случае операция завершается ошибкой. Это рекурсивное лишение прав затрагивает только права, 
полученные через цепочку пользователей, которую можно проследить до пользователя, являющегося субъектом команды `REVOKE`. 
Таким образом, пользователи могут в итоге сохранить это право, если оно было также получено через других пользователей.

Когда отзывается право доступа к таблице, с ним вместе автоматически отзываются соответствующие права 
для каждого столбца таблицы (если такие права заданы). 
С другой стороны, если роли были даны права для таблицы, лишение роли таких же прав на уровне отдельных столбцов ни на что не влияет.

Когда пользователь лишается членства в роли, указание `GRANT OPTION` меняется на `ADMIN OPTION`,
но в остальном поведение не отличается. 

Обратите внимание, что в версиях PostgreSQL до 16 при назначении членства в ролях зависимые права не отслеживались, 
то есть указание `CASCADE` при этом не действовало. Сейчас зависимые права отслеживаются. 

Заметьте также, что эта форма команды не принимает избыточное слово `GROUP` в указании_роли.
Можно отозвать право `INHERIT OPTION` или `SET OPTION` так же, как `ADMIN OPTION`. 
Это равнозначно присваиванию параметру значения `FALSE`.

---

## COPY

`COPY` — копировать данные между файлом и таблицей

### Синтаксис

**Копировать из файла в таблицу**
```postgres-sql
COPY имя_таблицы [ ( имя_столбца [, ...] ) ] FROM { 'имя_файла' | PROGRAM 'команда' | STDIN }
[ [ WITH ] ( параметр [, ...] ) ] [ WHERE условие ]
```

Копировать из таблицы в файл
```postgres-sql
COPY { имя_таблицы [ ( имя_столбца [, ...] ) ] | ( query ) }
TO { 'имя_файла' | PROGRAM 'команда' | STDOUT } [ [ WITH ] ( параметр [, ...] ) ]
```

Здесь допускается `параметр`:
```postgres-sql
FORMAT имя_формата
FREEZE [ boolean ]
DELIMITER 'символ_разделитель'
NULL 'маркер_NULL'
DEFAULT 'строка_по_умолчанию'
HEADER [ boolean | MATCH ]
QUOTE 'символ_кавычек'
ESCAPE 'символ_экранирования'
FORCE_QUOTE { ( имя_столбца [, ...] ) | * }
FORCE_NOT_NULL ( имя_столбца [, ...] )
FORCE_NULL ( имя_столбца [, ...] )
ENCODING 'имя_кодировки'
```

### Описание

`COPY` перемещает данные между таблицами PostgreSQL и обычными файлами в файловой системе.

`COPY TO` копирует содержимое таблицы в файл, а `COPY FROM` — из файла в таблицу (добавляет данные к тем, что уже содержались в таблице). 

`COPY TO` может также скопировать результаты запроса `SELECT`.

Если указывается список столбцов, `COPY TO` копирует в файл только данные указанных столбцов,
а `COPY FROM` вставляет каждое поле из файла в соответствующий ему по порядку столбец из указанного списка. 
В случае отсутствия в этом списке каких-либо столбцов таблицы при `COPY FROM` они получают значения по умолчанию.

`COPY` с именем файла указывает серверу PostgreSQL читать или записывать непосредственно этот файл. 
Заданный файл **должен быть доступен пользователю PostgreSQL** (тому пользователю, от имени которого работает сервер), 
и **путь к файлу должен задаваться с точки зрения сервера**. 

Для того чтобы выполнять копирование пользователь должен иметь права:
* _pg_read_server_files_ (чтение из файлов)
* _pg_write_server_files_ (запись файлов)

Когда указывается параметр `PROGRAM`, сервер выполняет заданную команду и читает данные из стандартного вывода программы, 
либо записывает их в стандартный ввод. 
Команда должна определяться с точки зрения сервера и быть доступной для исполнения пользователю PostgreSQL. 

Когда указывается `STDIN` или `STDOUT`, данные передаются через соединение клиента с сервером.
Каждый процесс, выполняющий операцию `COPY`, будет выдавать информацию о ходе её выполнения, 
отображаемую в представлении _pg_stat_progress_copy_. 

---

## SELECT

`SELECT, TABLE, WITH` — получить строки из таблицы или представления

### Синтаксис
```postgres-sql
[ WITH [ RECURSIVE ] запрос_WITH [, ...] ]
SELECT [ ALL | DISTINCT [ ON ( выражение [, ...] ) ] ] [ { * | выражение [ [ AS ] имя_результата ] } [, ...] ]
[ FROM элемент_FROM [, ...] ]
[ WHERE условие ]
[ GROUP BY [ ALL | DISTINCT ] элемент_группирования [, ...] ]
[ HAVING условие ]
[ WINDOW имя_окна AS ( определение_окна ) [, ...] ] 
[ { UNION | INTERSECT | EXCEPT } [ ALL | DISTINCT ] выборка ]
[ ORDER BY выражение [ ASC | DESC | USING оператор ] [ NULLS { FIRST | LAST } ] [, ...] ]
[ LIMIT { число | ALL } ]
[ OFFSET начало [ ROW | ROWS ] ]
[ FETCH { FIRST | NEXT } [ число ] { ROW | ROWS } { ONLY | WITH TIES } ]
[ FOR { UPDATE | NO KEY UPDATE | SHARE | KEY SHARE } [ OF имя_таблицы [, ...] ]
[ NOWAIT | SKIP LOCKED ] [...] ]
```

Здесь допускается `элемент_FROM`:
```postgres-sql
[ ONLY ] имя_таблицы [ * ] [ [ AS ] псевдоним [ ( псевдоним_столбца [, ...] ) ] ]
[ TABLESAMPLE метод_выборки ( аргумент [, ...] ) [ REPEATABLE ( затравка ) ] ]
[ LATERAL ] ( выборка ) 
[ [ AS ] псевдоним [ ( псевдоним_столбца [, ...] ) ] ]
имя_запроса_WITH [ [ AS ] псевдоним [ ( псевдоним_столбца [, ...] ) ] ]
[ LATERAL ] имя_функции ( [ аргумент [, ...] ] )
[ WITH ORDINALITY ] [ [ AS ] псевдоним [ ( псевдоним_столбца [, ...] ) ] ]
[ LATERAL ] имя_функции ( [ аргумент [, ...] ] ) [ AS ] псевдоним ( определение_столбца [, ...] )
[ LATERAL ] имя_функции ( [ аргумент [, ...] ] ) AS ( определение_столбца [, ...] )
[ LATERAL ] ROWS FROM( имя_функции ( [ аргумент [, ...] ] ) [ AS ( определение_столбца [, ...] ) ] [, ...] )
[ WITH ORDINALITY ] [ [ AS ] псевдоним [ ( псевдоним_столбца [, ...] ) ] ]
элемент_FROM тип_соединения элемент_FROM 
{ ON условие_соединения | USING ( столбец_соединения [, ...] ) [ AS псевдоним_использования_соединения ] }
элемент_FROM NATURAL тип_соединения элемент_FROM
элемент_FROM CROSS JOIN элемент_FROM
```

и `элемент_группирования` может быть следующим:
```postgres-sql
( )
выражение
( выражение [, ...] )
ROLLUP ( { выражение | ( выражение [, ...] ) } [, ...] )
CUBE ( { выражение | ( выражение [, ...] ) } [, ...] )
GROUPING SETS ( элемент_группирования [, ...] )
```

и `запрос_WITH`:
```postgres-sql
имя_запроса_WITH [ ( имя_столбца [, ...] ) ] AS [ [ NOT ] MATERIALIZED ] ( выборка | values | insert | update | delete )
[ SEARCH { BREADTH | DEPTH } FIRST BY имя_столбца [, ...]
SET имя_столбца_послед_поиска ]
[ CYCLE имя_столбца [, ...] SET имя_столбца_пометки_цикла
[ TO значение_пометки_цикла DEFAULT пометка_цикла_по_умолчанию ]
USING имя_столбца_пути_цикла ]
TABLE [ ONLY ] имя_таблицы [ * ]
```

### Описание

**_SELECT_** получает строки из множества таблиц (возможно, пустого). 

Общая процедура выполнения `SELECT` следующая:
1. Выполняются все запросы в списке `WITH`. По сути они формируют временные таблицы, 
к которым затем можно обращаться в списке `FROM`. 
Запрос в `WITH` без указания `NOT MATERIALIZED` выполняется только один раз, даже когда он фигурирует в списке `FROM` неоднократно.
2. Вычисляются все элементы в списке `FROM`. (Каждый элемент в списке `FROM` представляет собой реальную или виртуальную таблицу.) 
Если список `FROM` содержит несколько элементов, они объединяются перекрёстным соединением.
3. Если указано предложение `WHERE`, все строки, не удовлетворяющие условию, исключаются из результата.
4. Если присутствует указание `GROUP BY`, либо в запросе вызываются агрегатные функции, вывод разделяется по группам строк, 
соответствующим одному или нескольким значениям, а затем вычисляются результаты агрегатных функций. 
Если добавлено предложение `HAVING`, оно исключает группы, не удовлетворяющие заданному условию. 
Хотя столбцы вывода запроса номинально вычисляются на следующем шаге, 
на них также можно ссылаться (по имени или порядковому номеру) в предложении `GROUP BY`.
5. Вычисляются фактические выходные строки по заданным в `SELECT` выражениям для каждой выбранной строки или группы строк.
6. `SELECT DISTINCT` исключает из результата повторяющиеся строки. 
`SELECT DISTINCT ON` исключает строки, совпадающие по всем указанным выражениям. 
`SELECT ALL` (по умолчанию) возвращает все строки результата, включая дубликаты.
7. Операторы `UNION`, `INTERSECT` и `EXCEPT` объединяют вывод нескольких команд `SELECT` в один результирующий набор. 
   + Оператор `UNION` возвращает все строки, представленные в одном, либо обоих наборах результатов. 
   + Оператор `INTERSECT` возвращает все строки, представленные строго в обоих наборах. 
   + Оператор `EXCEPT` возвращает все строки, представленные в первом наборе, но не во втором. 
   
Во всех трёх случаях повторяющиеся строки исключаются из результата, если явно не указано `ALL`. 
Чтобы явно обозначить, что выдаваться должны только неповторяющиеся строки, можно добавить избыточное слово `DISTINCT`. 
Заметьте, что в данном контексте по умолчанию подразумевается `DISTINCT`, хотя в самом `SELECT` по умолчанию подразумевается `ALL`.
8. Если присутствует предложение `ORDER BY`, возвращаемые строки сортируются в указанном порядке. 
В отсутствие `ORDER BY` строки возвращаются в том порядке, в каком системе будет проще их выдать.
9. Если указано предложение `LIMIT` (или `FETCH FIRST`) либо `OFFSET`, 
оператор `SELECT` возвращает только подмножество строк результата.
10. Если указано `FOR UPDATE`, `FOR NO KEY UPDATE`, `FOR SHARE` или `FOR KEY SHARE`, 
оператор `SELECT` блокирует выбранные строки, защищая их от одновременных изменений.
   
Для всех столбцов, задействованных в команде `SELECT`, необходимо иметь право `SELECT`. 
Применение блокировок `FOR NO KEY UPDATE`, `FOR UPDATE`, `FOR SHARE` или `FOR KEY SHARE` требует также права
`UPDATE` (как минимум для одного столбца в каждой выбранной для блокировки таблице).

---