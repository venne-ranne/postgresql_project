CREATE TABLE banks(
 bank_name VARCHAR(125) NOT NULL,
 city VARCHAR(80) NOT NULL,
 no_accounts int DEFAULT 0,
 security VARCHAR(12),
 PRIMARY KEY (bank_name, city),
 CONSTRAINT check_account_num CHECK (no_accounts >= 0)
);
\copy banks from 'banks_17.data'



CREATE TABLE robberies(
 bank_name varchar(125),
 city VARCHAR(80),
 date DATE NOT NULL,
 amount NUMERIC(12, 2),
 PRIMARY KEY (bank_name, city, date),
 FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);
\copy robberies from 'robberies_17.data'




CREATE TABLE robbers(
 robber_id SERIAL NOT NULL,
 nickname CITEXT NOT NULL UNIQUE,
 age int,
 no_years int DEFAULT 0,
 PRIMARY KEY (robber_id),
 CONSTRAINT check_age CHECK (age > 0),
 CONSTRAINT check_prison_years CHECK (no_years <= age)
);
\copy robbers(nickname, age, no_years) from 'robbers_17.data'


CREATE TABLE skills(
 skill_id SERIAL NOT NULL,
 description CITEXT NOT NULL,
 PRIMARY KEY (skill_id),
 CONSTRAINT must_be_different UNIQUE (description)
);

CREATE TABLE has_skills(
 robber_id int NOT NULL,
 skill_id int NOT NULL,
 preference int,
 grade CHAR(2),
 PRIMARY KEY (robber_id, skill_id),
 FOREIGN KEY (robber_id) REFERENCES robbers(robber_id),
 FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);

CREATE TABLE accomplices(
 robber_id int NOT NULL,
 bank_name VARCHAR(125) NOT NULL,
 city VARCHAR(80) NOT NULL,
 robbery_date DATE NOT NULL,
 share NUMERIC(12,2),
 PRIMARY KEY (robber_id, bank_name, city, robbery_date),
 FOREIGN KEY (robber_id) REFERENCES robbers(robber_id),
 FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);

CREATE TABLE plans(
 bank_name varchar(125) NOT NULL,
 city VARCHAR(80) NOT NULL,
 planned_date DATE NOT NULL,
 no_robbers int,
 PRIMARY KEY (bank_name, city, planned_date),
 FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);
\copy plans (bank_name, city, planned_date, no_robbers) from 'plans_17.data'


insert into skills (description) select city from banks group by city;
insert into banks values('sdsdsd', (select description from skills where id = 1), 3424324, 'good' );


CREATE TABLE has_accounts(
 robber_id int NOT NULL,
 bank_name varchar(125) NOT NULL,
 city VARCHAR(80) NOT NULL,
 PRIMARY KEY (robber_id, bank_name, city),
 FOREIGN KEY (robber_id) REFERENCES robbers(robber_id),
 FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);

CREATE TABLE has_accounts_raw(
 robber_id int,
 nickname CITEXT NOT NULL,
 bank_name varchar(125) NOT NULL,
 city VARCHAR(80) NOT NULL,
 FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);
\copy has_accounts_raw(nickname, bank_name, city) from 'hasaccounts_17.data'
UPDATE has_accounts_raw SET robber_id = (SELECT robber_id FROM robbers WHERE has_accounts_raw.nickname = nickname);
-- to check if any column contain no robber_id
select * from has_accounts_raw where robber_id IS NULL;
INSERT INTO has_accounts (SELECT DISTINCT robber_id, bank_name, city FROM has_accounts_raw);

CREATE TABLE has_skills_raw(
 robber_id int,
 nickname VARCHAR(80) NOT NULL,
 skill VARCHAR(80) NOT NULL,
 skill_id int,
 preference int,
 grade CHAR(2)
);

\copy has_skills_raw(nickname, skill, preference, grade) from 'hasskills_17.data'
INSERT INTO skills (description) SELECT skill FROM has_skills_raw GROUP BY skill;
UPDATE has_skills_raw SET robber_id = (SELECT robber_id FROM robbers WHERE has_skills_raw.nickname = nickname);
UPDATE has_skills_raw SET skill_id = (SELECT skill_id FROM skills WHERE has_skills_raw.skill = description);
INSERT INTO has_skills (SELECT DISTINCT robber_id, skill_id, preference, grade FROM has_skills_raw);


-- Instead of using the text data type, we can use the citext (case insensitive text) type!
-- First we need to enable the citext extension:
CREATE EXTENSION IF NOT EXISTS citext;

alter table has_accounts_raw add column robber_id int;

--  Clyde             |         8 | Inter-Gang Bank | Evanston | 2012-02-16   | 12103.00
 Clyde             |         8 | Loanshark Bank  | Evanston | 2013-04-20   |  2747.00
 Clyde             |         8 | Penny Pinchers  | Chicago  | 2009-08-30   |   450.00
 Clyde             |         8 | Penny Pinchers  | Evanston | 2009-08-30   | 16500.00
CREATE TABLE accomplices_raw(
 nickname CITEXT NOT NULL,
 robber_id int,
 bank_name VARCHAR(125) NOT NULL,
 city VARCHAR(80) NOT NULL,
 robbery_date DATE NOT NULL,
 share NUMERIC(12,2),
 FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);
\copy accomplices_raw(nickname, bank_name, city, robbery_date, share) from 'accomplices_17.data'
UPDATE accomplices_raw SET robber_id = (SELECT robber_id FROM robbers WHERE accomplices_raw.nickname = nickname);
SELECT * FROM accomplices_raw WHERE robber_id IS NULL;
INSERT INTO accomplices (SELECT DISTINCT robber_id, bank_name, city, robbery_date, share FROM accomplices_raw);
