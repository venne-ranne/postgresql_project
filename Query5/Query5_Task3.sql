----- Stepwise approach for task 3 -----
CREATE VIEW robbers_info AS
SELECT robber_id, nickname, skill_id, bank_name, city
FROM accomplices
    NATURAL INNER JOIN robbers
    NATURAL INNER JOIN has_skills;

CREATE VIEW robbers_skills AS
SELECT robber_id, nickname, description, bank_name, city
FROM robbers_info NATURAL INNER JOIN skills;

CREATE VIEW banks_info AS
SELECT robber_id, nickname, description, security
FROM robbers_skills NATURAL INNER JOIN banks;

CREATE VIEW suspects_list AS
SELECT security AS "Security", description AS "Description", nickname AS "Nickname"
FROM banks_info
GROUP BY security, description, nickname
ORDER BY security;

----- Single nested SQL query for task 3 -----
SELECT DISTINCT security AS "Security", description AS "Description", nickname AS "Nickname"
FROM accomplices
  NATURAL INNER JOIN has_skills
  NATURAL INNER JOIN skills
  NATURAL INNER JOIN banks
  NATURAL INNER JOIN robbers
ORDER BY security;
