-- Instead of using the text data type, we can use the citext (case insensitive text) type!
-- First we need to enable the citext extension: CREATE EXTENSION IF NOT EXISTS citext;
-- Unfortunately, the PostgreSQL in the lab has an ERROR: could not open extension control file "/usr/pkg/share/postgresql/extension/citext.control": No such file or directory

CREATE TABLE banks(
   bank_name VARCHAR(80) NOT NULL,
   city VARCHAR(25) NOT NULL,
   no_accounts int DEFAULT 0,
   security VARCHAR(12),
   PRIMARY KEY (bank_name, city),
   CONSTRAINT check_account_num CHECK (no_accounts >= 0),
   CONSTRAINT check_security_input CHECK (security IN ('weak', 'excellent', 'very good', 'good'))
);

CREATE TABLE robberies(
   bank_name VARCHAR(80) NOT NULL,
   city VARCHAR(25) NOT NULL,
   robbery_date DATE NOT NULL,
   amount NUMERIC(12, 2),
   PRIMARY KEY (bank_name, city, robbery_date),
   FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);

CREATE TABLE plans(
   bank_name VARCHAR(80) NOT NULL,
   city VARCHAR(25) NOT NULL,
   planned_date DATE NOT NULL,
   no_robbers int,
   PRIMARY KEY (bank_name, city, planned_date),
   FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city),
   CONSTRAINT check_no_robbers CHECK (no_robbers >= 0)
);

CREATE TABLE robbers(
   robber_id SERIAL NOT NULL,
   nickname VARCHAR(70) NOT NULL UNIQUE,
   age int,
   no_years int DEFAULT 0,
   PRIMARY KEY (robber_id),
   CONSTRAINT check_age CHECK (age > 0),
   CONSTRAINT check_prison_years CHECK (no_years <= age)
);

CREATE TABLE has_accounts(
   robber_id int NOT NULL,
   bank_name VARCHAR(80) NOT NULL,
   city VARCHAR(25) NOT NULL,
   PRIMARY KEY (robber_id, bank_name, city),
   FOREIGN KEY (robber_id) REFERENCES robbers(robber_id),
   FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);

CREATE TABLE skills(
   skill_id SERIAL NOT NULL,
   description VARCHAR(25) NOT NULL UNIQUE,
   PRIMARY KEY (skill_id),
   CONSTRAINT must_be_different UNIQUE (description)
);

CREATE FUNCTION get_max(id int) RETURNS int AS
$max$
    DECLARE
        total int;
    BEGIN
        SELECT COUNT(preference)
        FROM has_skills
        WHERE robber_id = id
        GROUP BY robber_id INTO total;
        RETURN total;
    END;
$max$
LANGUAGE plpgsql;

CREATE TABLE has_skills(
   robber_id int NOT NULL,
   skill_id int NOT NULL,
   preference int,
   grade CHAR(2),
   PRIMARY KEY (robber_id, skill_id),
   FOREIGN KEY (robber_id) REFERENCES robbers(robber_id),
   FOREIGN KEY (skill_id) REFERENCES skills(skill_id),
   CONSTRAINT check_preference_input CHECK (preference > 0),
   CONSTRAINT check_preference_num CHECK (preference = get_max(robber_id)+1)
);

CREATE TABLE accomplices(
   robber_id int NOT NULL,
   bank_name VARCHAR(80) NOT NULL,
   city VARCHAR(25) NOT NULL,
   robbery_date DATE NOT NULL,
   share NUMERIC(12,2),
   PRIMARY KEY (robber_id, bank_name, city, robbery_date),
   FOREIGN KEY (robber_id) REFERENCES robbers(robber_id),
   FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);
