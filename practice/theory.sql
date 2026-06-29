CREATE TABLE weather (
    city    varchar(80),
    temp_lo int,
    temp_hi int,
    prcp    real,
    date    date
);

INSERT INTO weather VALUES
    ('San Francisco', 46, 50, 0.25, '1994-11-27'),
    ('San Francisco', 43, 57, 0.0,  '1994-11-29'),
    ('Hayward',       37, 54, NULL, '1994-11-29');

SELECT * FROM weather;

SELECT city, (temp_hi + temp_lo) / 2 AS temp_avg, date
FROM weather;

SELECT *
FROM weather
WHERE city = 'San Francisco' AND prcp > 0.0;

SELECT * FROM weather ORDER BY city, temp_lo;

SELECT DISTINCT city FROM weather ORDER BY city;

CREATE TABLE cities (
    name     varchar(80),
    location point
);

INSERT INTO cities VALUES
    ('San Francisco', '(-194.0, 53.0)'),
    ('Los Angeles',   '(-118.0, 34.0)');

SELECT city, temp_lo, temp_hi, prcp, date, location
FROM weather
JOIN cities ON city = name;

SELECT *
FROM weather
LEFT OUTER JOIN cities ON weather.city = cities.name;

DROP TABLE IF EXISTS weather CASCADE;
DROP TABLE IF EXISTS cities CASCADE;

CREATE TABLE cities (
    name     varchar(80) PRIMARY KEY,
    location point
);

CREATE TABLE weather (
    city    varchar(80) REFERENCES cities(name),
    temp_lo int,
    temp_hi int,
    prcp    real,
    date    date
);

INSERT INTO cities VALUES ('San Francisco', '(-194.0, 53.0)');

INSERT INTO weather VALUES ('San Francisco', 46, 50, 0.25, '1994-11-27');

INSERT INTO weather VALUES ('Berkeley', 45, 53, 0.0, '1994-11-28');

CREATE TABLE empsalary (
    depname varchar(100),
    empno   int,
    salary  int
);

INSERT INTO empsalary(depname, empno, salary) VALUES
    ('develop',   11, 5200),
    ('develop',    7, 4200),
    ('develop',    9, 4500),
    ('develop',    8, 6000),
    ('develop',   10, 5200),
    ('personnel',  5, 3500),
    ('personnel',  2, 3900),
    ('sales',      3, 4800),
    ('sales',      1, 5000),
    ('sales',      4, 4800);

SELECT depname, empno, salary,
       avg(salary) OVER (PARTITION BY depname)
FROM empsalary;

SELECT depname, empno, salary,
       rank() OVER (PARTITION BY depname ORDER BY salary DESC)
FROM empsalary;

SELECT salary, sum(salary) OVER () FROM empsalary;

SELECT salary, sum(salary) OVER (ORDER BY salary) FROM empsalary;

DROP TABLE IF EXISTS capitals CASCADE;
DROP TABLE IF EXISTS cities CASCADE;

CREATE TABLE cities (
    name       text,
    population real,
    elevation  int
);

CREATE TABLE capitals (
    state char(2) UNIQUE NOT NULL
) INHERITS (cities);

INSERT INTO cities (name, population, elevation) VALUES
    ('New York',      8335897,   33),
    ('Los Angeles',   3822238,  285),
    ('Chicago',       2665039,  597),
    ('San Francisco',  808437,   52),
    ('Seattle',        749256,  175);

INSERT INTO capitals (name, population, elevation, state) VALUES
    ('Sacramento', 524943,   30, 'CA'),
    ('Austin',     961855,  489, 'TX'),
    ('Denver',     715522, 5280, 'CO'),
    ('Albany',      99224,  150, 'NY'),
    ('Olympia',     55605,  112, 'WA');

SELECT name, elevation FROM cities WHERE elevation > 500;

SELECT name, elevation FROM ONLY cities WHERE elevation > 500;

CREATE TABLE products (
    product_no integer PRIMARY KEY,
    name       text NOT NULL,
    price      numeric CHECK (price > 0)
);

INSERT INTO products VALUES (1, 'Notebook', 9.99);

INSERT INTO products VALUES (1, 'Pen', 2.50);
