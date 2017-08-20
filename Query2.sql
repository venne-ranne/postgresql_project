
\copy banks from 'banks_17.data'
\copy robberies from 'robberies_17.data'
\copy plans (bank_name, city, planned_date, no_robbers) from 'plans_17.data'
\copy robbers(nickname, age, no_years) from 'robbers_17.data'

CREATE TABLE has_accounts_test(
   robber_id int NOT NULL,
   bank_name VARCHAR(80) NOT NULL,
   city VARCHAR(25) NOT NULL,
   PRIMARY KEY (robber_id, bank_name, city),
   FOREIGN KEY (robber_id) REFERENCES robbers(robber_id),
   FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);

CREATE TABLE has_accounts_raw(
   robber_id int,
   nickname VARCHAR(70) NOT NULL,
   bank_name VARCHAR(80) NOT NULL,
   city VARCHAR(25) NOT NULL,
   FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);
\copy has_accounts_raw(nickname, bank_name, city) from 'hasaccounts_17.data'
-- update the robber_id in the dummy table has_accounts_raw using the robbers table
UPDATE has_accounts_raw SET robber_id = (SELECT robber_id FROM robbers WHERE has_accounts_raw.nickname = nickname);

-- to check if any column contain no robber_id
select * from has_accounts_raw where robber_id IS NULL;

-- insert the rows from the dummy table has_accounts_raw into the original table has_accounts
INSERT INTO has_accounts (SELECT DISTINCT robber_id, bank_name, city FROM has_accounts_raw);

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

ALTER TABLE has_skills ADD CONSTRAINT check_preference_num CHECK (preference == get_max(robber_id)+1);
--CONSTRAINT check_preference_increment CHECK (preference = (get_max(robber_id)+1))

CREATE TABLE has_skills_raw(
   robber_id int,
   nickname VARCHAR(70) NOT NULL,
   skill VARCHAR(80) NOT NULL,
   skill_id int,
   preference int,
   grade CHAR(2)
);
\copy has_skills_raw(nickname, skill, preference, grade) from 'hasskills_17.data'

-- insert the skill description into the skills table
INSERT INTO skills (description) (SELECT skill FROM has_skills_raw GROUP BY skill);

-- insert robber_id from robbers table into the column robber_id of has_skills_raw table
UPDATE has_skills_raw SET robber_id = (SELECT robber_id FROM robbers WHERE has_skills_raw.nickname = nickname);
-- To ensure all the rows in the column robber_id is not NULL and the result must return 0 rows
select * from has_skills_raw where robber_id IS NULL;

-- insert skill_id from skills table into the column skill_id of has_skills_raw table
UPDATE has_skills_raw SET skill_id = (SELECT skill_id FROM skills WHERE has_skills_raw.skill = description);
-- To ensure all the rows in the column skill_id is not NULL and the result must return 0 rows
select * from has_skills_raw where skill_id IS NULL;

-- insert all rows from the dummy table has_skills_raw into the original has_skills table
INSERT INTO has_skills (SELECT DISTINCT robber_id, skill_id, preference, grade FROM has_skills_raw ORDER BY robber_id, preference);


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


CREATE TABLE accomplices_raw(
   nickname VARCHAR(70) NOT NULL,
   robber_id int,
   bank_name VARCHAR(80) NOT NULL,
   city VARCHAR(25) NOT NULL,
   robbery_date DATE NOT NULL,
   share NUMERIC(12,2),
   FOREIGN KEY (bank_name, city) REFERENCES banks(bank_name, city)
);
\copy accomplices_raw(nickname, bank_name, city, robbery_date, share) from 'accomplices_17.data'

-- update the robber_id in the dummy table accomplices_raw using the robbers table
UPDATE accomplices_raw SET robber_id = (SELECT robber_id FROM robbers WHERE accomplices_raw.nickname = nickname);
-- To ensure all the rows in the column robber_id is not NULL and the result must return 0 rows
SELECT * FROM accomplices_raw WHERE robber_id IS NULL;

-- insert all rows from the dummy table accomplices_raw into the original accomplices table
INSERT INTO accomplices (SELECT DISTINCT robber_id, bank_name, city, robbery_date, share FROM accomplices_raw);


-- banks (bank_name, city, no_accounts, security) with primary key {bank_name, city}
-- robberies(bank_name, city, robbery_date, amount) with primary key {bank_name, city, robbery_date} and foreign key SID  SUPPLIER[SID]
Attributes: BankName, City, Date, Amount
• Plans, which stores information about banks that the gang plans to rob.
Attributes: BankName, City, NoRobbers, PlannedDate
• Robbers, which stores information about gang members. Note that it is not possible to be in prison for more years than you have been alive!
Attributes: RobberId, Nickname, Age, NoYears
• Skills, which stores the possible robbery skills.
Attributes: SkillId, Description
• HasSkills, which stores information about the skills that particular gang members possess.
Each skill of a robber has a preference rank, and a grade.
Attributes: RobberId, SkillId, Preference, Grade
• HasAccounts, which stores information about the banks where individual gang members
have accounts.
Attributes: RobberId, BankName, City
• Accomplices, which stores information about which gang members participated in each
bank robbery, and what share of the money they got.
Attributes: RobberId, BankName, City, RobberyDate, Share
