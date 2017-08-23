
-- QUESTION 5: Complex Database Queries [35 marks]
-- You are again expected to use SQL as a query language to retrieve data from the database.
-- Perform the series of 5 tasks listed below. For each task, you must construct SQL queries in
-- two ways: stepwise, and as a single nested SQL query.
-- The stepwise approach of computing complex queries consists of a sequence of basic (not
-- nested) SQL queries. The results of each query must be put into a virtual or a materialised view
-- (with the CREATE VIEW … AS SELECT … command, or the CREATE TABLE … AS
-- SELECT … command). The output of the last query should be the requested result. The first
-- query in the sequence uses the base relations as input. Each subsequent query in the sequence
-- may use the base relations and/or the intermediate results of the preceding views as input.

-- 1. The police department wants to know which robbers are most active, but were never
-- penalised. Construct a view that contains the Nicknames of all robbers who participated in
-- more robberies than the average, but spent no time in prison. The answer should be sorted
-- in decreasing order of the individual total “earnings” of the robbers. [7 marks]

----- Stepwise approach for task 1 -----
CREATE VIEW total_robberies AS
SELECT nickname, COUNT(robber_id) AS total, SUM(share) AS share
FROM robbers
    NATURAL INNER JOIN accomplices
GROUP BY robber_id
HAVING robbers.no_years = 0
ORDER BY SUM(share) DESC;

CREATE VIEW avg_robberies AS
SELECT ROUND(AVG(total), 0) AS avg_robberies
FROM total_robberies;

CREATE VIEW most_active_robbers AS
SELECT total_robberies.nickname AS "Nickname"
FROM total_robberies
    NATURAL INNER JOIN avg_robberies
WHERE (total > avg_robberies);

    Nickname
----------------
 Bonnie
 Clyde
 Sonny Genovese
(3 rows)


----- Single nested SQL query for task 1 -----
SELECT (SELECT nickname
        FROM robbers
        WHERE accomplices.robber_id = robbers.robber_id) AS "Nickname"
FROM accomplices
GROUP BY accomplices.robber_id
HAVING (COUNT(accomplices.robber_id) > (SELECT (COUNT(*)/COUNT(DISTINCT accomplices.robber_id))
                                        FROM accomplices))
       AND (SELECT no_years
            FROM robbers
            WHERE accomplices.robber_id = robbers.robber_id) = 0
ORDER BY SUM(accomplices.share) DESC;

    Nickname
----------------
 Bonnie
 Clyde
 Sonny Genovese
(3 rows)



-- 2. The police department wants to know whether bank branches with lower security levels are
-- more attractive for robbers than those with higher security levels. Construct a view
-- containing the Security level, the total Number of robberies that occurred in bank branches
-- of that security level, and the average Amount of money that was stolen during these
-- robberies. [7 marks]

----- Stepwise approach for task 2 -----
CREATE VIEW merge_banks_info AS
SELECT bank_name, city, COUNT(*) AS total_robberies, SUM(amount) AS total_money
FROM robberies
GROUP BY bank_name, city;

CREATE VIEW bank_securities AS
SELECT security AS "Security",
       SUM(total_robberies) AS "Total # of robberies",
       ROUND((SUM(total_money)/SUM(total_robberies)), 2) AS "Average amount of money"
FROM merge_banks_info
    NATURAL INNER JOIN banks
GROUP BY security;

 Security  | Total # of robberies | Average amount of money
-----------+----------------------+-------------------------
 weak      |                    4 |                 2299.50
 excellent |                   12 |                39238.08
 very good |                    3 |                12292.43
 good      |                    2 |                 3980.00
(4 rows)

----- Single nested SQL query for task 2 -----
SELECT bank_robberies.security AS "Security",
       COUNT(*) AS "Total # of robberies",
       ROUND((SUM(amount)/ COUNT(*)), 2) AS "Average amount of money"
FROM (SELECT banks.bank_name, banks.city, banks.security, robberies.amount
      FROM robberies, banks
      WHERE banks.bank_name = robberies.bank_name AND
            banks.city = robberies.city) AS bank_robberies
GROUP BY bank_robberies.security;

 Security  | Total # of robberies | Average amount of money
-----------+----------------------+-------------------------
 weak      |                    4 |                 2299.50
 good      |                    2 |                 3980.00
 excellent |                   12 |                39238.08
 very good |                    3 |                12292.43
(4 rows)



-- 3. The police department wants to know which robbers are most likely to attack a particular
-- bank branch. Robbing bank branches with a certain security level might require certain
-- skills. For example, maybe every robbery of a branch with “excellent” security requires a
-- robber with “Explosives” skill. Construct a view containing Security level, Skill, and
-- Nickname showing for each security level all those skills that were possessed by some
-- participating robber in each robbery of a bank branch of the respective security level, and
-- the nicknames of all robbers who have that skill. [7 marks]

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

Security  |  Description   |     Nickname
-----------+----------------+-------------------
 excellent | Driving        | Bugsy Siegel
 excellent | Driving        | Dutch Schulz
 excellent | Driving        | Longy Zwillman
 excellent | Driving        | Lucky Luchiano
 excellent | Driving        | Mimmy The Mau Mau
 excellent | Explosives     | Sonny Genovese
 excellent | Guarding       | Anastazia
 excellent | Guarding       | Bugsy Siegel
 excellent | Gun-Shooting   | Waxey Gordon
 excellent | Lock-Picking   | Clyde
 excellent | Lock-Picking   | Dutch Schulz
 excellent | Lock-Picking   | Greasy Guzik
 excellent | Lock-Picking   | Lucky Luchiano
 excellent | Lock-Picking   | Sonny Genovese
 excellent | Planning       | Al Capone
 excellent | Planning       | Boo Boo Hoff
 excellent | Planning       | Clyde
 excellent | Planning       | King Solomon
 excellent | Planning       | Mimmy The Mau Mau
 excellent | Preaching      | Al Capone
 excellent | Preaching      | Bonnie
 excellent | Preaching      | Greasy Guzik
 excellent | Safe-Cracking  | Al Capone
 excellent | Safe-Cracking  | Meyer Lansky
 excellent | Safe-Cracking  | Sonny Genovese
 excellent | Scouting       | Clyde
 good      | Cooking        | Vito Genovese
 good      | Eating         | Vito Genovese
 good      | Money Counting | Kid Cann
 good      | Money Counting | Mickey Cohen
 good      | Scouting       | Vito Genovese
 very good | Driving        | Lepke Buchalter
 very good | Driving        | Longy Zwillman
 very good | Explosives     | Bugsy Malone
 very good | Explosives     | Sonny Genovese
 very good | Guarding       | Anastazia
 very good | Guarding       | Lepke Buchalter
 very good | Lock-Picking   | Sonny Genovese
 very good | Planning       | Al Capone
 very good | Planning       | King Solomon
 very good | Preaching      | Al Capone
 very good | Safe-Cracking  | Al Capone
 very good | Safe-Cracking  | Moe Dalitz
 very good | Safe-Cracking  | Sonny Genovese
 weak      | Cooking        | Vito Genovese
 weak      | Driving        | Bugsy Siegel
 weak      | Driving        | Dutch Schulz
 weak      | Driving        | Lepke Buchalter
 weak      | Eating         | Vito Genovese
 weak      | Explosives     | Sonny Genovese
 weak      | Guarding       | Bugsy Siegel
 weak      | Guarding       | Lepke Buchalter
 weak      | Lock-Picking   | Clyde
 weak      | Lock-Picking   | Dutch Schulz
 weak      | Lock-Picking   | Greasy Guzik
 weak      | Lock-Picking   | Sonny Genovese
 weak      | Planning       | Al Capone
 weak      | Planning       | Boo Boo Hoff
 weak      | Planning       | Clyde
 weak      | Preaching      | Al Capone
 weak      | Preaching      | Greasy Guzik
 weak      | Safe-Cracking  | Al Capone
 weak      | Safe-Cracking  | Sonny Genovese
 weak      | Scouting       | Clyde
 weak      | Scouting       | Vito Genovese
(65 rows)

----- Single nested SQL query for task 3 -----
SELECT DISTINCT security AS "Security", description AS "Description", nickname AS "Nickname"
FROM accomplices
  NATURAL INNER JOIN has_skills
  NATURAL INNER JOIN skills
  NATURAL INNER JOIN banks
  NATURAL INNER JOIN robbers
ORDER BY security;

SELECT DISTINCT banks.security AS "Security",
                skills.description AS "Description",
                banks.nickname AS "Nickname"
FROM (SELECT DISTINCT security, nickname, robber_id
      FROM accomplices
        NATURAL INNER JOIN banks
        NATURAL INNER JOIN robbers) AS banks,
     (SELECT DISTINCT skill_id, description, robber_id
      FROM skills
        NATURAL INNER JOIN has_skills) AS skills
WHERE banks.robber_id = skills.robber_id
ORDER BY banks.security;

Security  |  Description   |     Nickname
-----------+----------------+-------------------
 excellent | Driving        | Bugsy Siegel
 excellent | Driving        | Dutch Schulz
 excellent | Driving        | Longy Zwillman
 excellent | Driving        | Lucky Luchiano
 excellent | Driving        | Mimmy The Mau Mau
 excellent | Explosives     | Sonny Genovese
 excellent | Guarding       | Anastazia
 excellent | Guarding       | Bugsy Siegel
 excellent | Gun-Shooting   | Waxey Gordon
 excellent | Lock-Picking   | Clyde
 excellent | Lock-Picking   | Dutch Schulz
 excellent | Lock-Picking   | Greasy Guzik
 excellent | Lock-Picking   | Lucky Luchiano
 excellent | Lock-Picking   | Sonny Genovese
 excellent | Planning       | Al Capone
 excellent | Planning       | Boo Boo Hoff
 excellent | Planning       | Clyde
 excellent | Planning       | King Solomon
 excellent | Planning       | Mimmy The Mau Mau
 excellent | Preaching      | Al Capone
 excellent | Preaching      | Bonnie
 excellent | Preaching      | Greasy Guzik
 excellent | Safe-Cracking  | Al Capone
 excellent | Safe-Cracking  | Meyer Lansky
 excellent | Safe-Cracking  | Sonny Genovese
 excellent | Scouting       | Clyde
 good      | Cooking        | Vito Genovese
 good      | Eating         | Vito Genovese
 good      | Money Counting | Kid Cann
 good      | Money Counting | Mickey Cohen
 good      | Scouting       | Vito Genovese
 very good | Driving        | Lepke Buchalter
 very good | Driving        | Longy Zwillman
 very good | Explosives     | Bugsy Malone
 very good | Explosives     | Sonny Genovese
 very good | Guarding       | Anastazia
 very good | Guarding       | Lepke Buchalter
 very good | Lock-Picking   | Sonny Genovese
 very good | Planning       | Al Capone
 very good | Planning       | King Solomon
 very good | Preaching      | Al Capone
 very good | Safe-Cracking  | Al Capone
 very good | Safe-Cracking  | Moe Dalitz
 very good | Safe-Cracking  | Sonny Genovese
 weak      | Cooking        | Vito Genovese
 weak      | Driving        | Bugsy Siegel
 weak      | Driving        | Dutch Schulz
 weak      | Driving        | Lepke Buchalter
 weak      | Eating         | Vito Genovese
 weak      | Explosives     | Sonny Genovese
 weak      | Guarding       | Bugsy Siegel
 weak      | Guarding       | Lepke Buchalter
 weak      | Lock-Picking   | Clyde
 weak      | Lock-Picking   | Dutch Schulz
 weak      | Lock-Picking   | Greasy Guzik
 weak      | Lock-Picking   | Sonny Genovese
 weak      | Planning       | Al Capone
 weak      | Planning       | Boo Boo Hoff
 weak      | Planning       | Clyde
 weak      | Preaching      | Al Capone
 weak      | Preaching      | Greasy Guzik
 weak      | Safe-Cracking  | Al Capone
 weak      | Safe-Cracking  | Sonny Genovese
 weak      | Scouting       | Clyde
 weak      | Scouting       | Vito Genovese
(65 rows)


-- 4. The police department wants to increase security at those bank branches that are most
-- likely to be victims in the near future. Construct a view containing the BankName, the City,
-- and Security level of all bank branches that have not been robbed in the previous year, but
-- where plans for a robbery next year are known. The answer should be sorted in decreasing
-- order of the number of robbers who have accounts in that bank branch. [7 marks]

----- Stepwise approach for task 4 -----
CREATE VIEW never_been_robbed AS
SELECT DISTINCT banks.bank_name, banks.city, banks.security, banks.no_accounts
FROM banks
  FULL JOIN robberies ON robberies.bank_name = banks.bank_name AND
                         robberies.city = banks.city AND
                         NOT (robberies.robbery_date BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL '1 year')
GROUP BY banks.bank_name, banks.city;

CREATE VIEW planned_robberies AS
SELECT DISTINCT bank_name, city, security, no_accounts
FROM banks
    NATURAL JOIN plans
WHERE (planned_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '1 year')
GROUP BY bank_name, city
ORDER BY no_accounts DESC;

CREATE VIEW target_banks AS
SELECT bank_name AS "BankName", city AS "City", security AS "Security"
FROM planned_robberies NATURAL INNER JOIN never_been_robbed
ORDER BY planned_robberies.no_accounts DESC;

   BankName     |   City    | Security
----------------+-----------+-----------
Loanshark Bank  | Deerfield | very good
PickPocket Bank | Deerfield | excellent
Bad Bank        | Chicago   | weak
(3 rows)

----- Single nested SQL query for task 4 -----
SELECT target_banks.bank_name AS "BankName",
       target_banks.city AS "City",
       target_banks.security AS "Security"
FROM (SELECT DISTINCT plans.bank_name, plans.city, banks.security, banks.no_accounts
      FROM plans NATURAL JOIN banks
      WHERE plans.planned_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '1 year' AND
            NOT EXISTS (SELECT *
                        FROM robberies
                        WHERE robberies.robbery_date BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL '1 year')) AS target_banks
ORDER BY target_banks.no_accounts DESC;

   BankName     |   City    | Security
----------------+-----------+-----------
Loanshark Bank  | Deerfield | very good
PickPocket Bank | Deerfield | excellent
Bad Bank        | Chicago   | weak
(3 rows)








-- 5. The police department has a theory that bank robberies in Chicago are more profitable
-- than in any other city in their district. Construct a view that shows the average share of all
-- robberies in Chicago, and the average share of all robberies for that city (other than
-- Chicago) that observes the highest average share. The average share of a robbery is
-- computed based on the number of participants in that particular robbery. [7 marks]

----- Stepwise approach for task 5 -----
CREATE VIEW chicago_avg AS
SELECT ROUND((SUM(share)/COUNT(robber_id)), 2) AS avg
FROM accomplices
WHERE city = 'Chicago';

CREATE VIEW others_avg AS
SELECT ROUND((SUM(share)/COUNT(robber_id)), 2) AS avg
FROM accomplices
WHERE NOT(city = 'Chicago');

CREATE VIEW avg_share AS
SELECT chicago_avg.avg AS "Average share in Chicago",
       others_avg.avg AS "Average share in other cities"
FROM chicago_avg, others_avg;

 Average share in Chicago | Average share in other cities
--------------------------+-------------------------------
                  4221.41 |                       8255.16
(1 row)

----- Single nested SQL query for task 5 -----
SELECT chicago.average AS "Average share in Chicago", others.average AS "Average share in other cities"
FROM (SELECT ROUND((SUM(share)/COUNT(robber_id)), 2) AS "average"
      FROM accomplices
      WHERE accomplices.city = 'Chicago') AS chicago,
     (SELECT ROUND((SUM(share)/COUNT(robber_id)), 2) AS "average"
      FROM accomplices
      WHERE NOT(accomplices.city = 'Chicago')) AS others;

 Average share in Chicago | Average share in other cities
--------------------------+-------------------------------
                  4221.41 |                       8255.16
(1 row)

----- EXTRAS: Other approach for task 5 -----
SELECT
    ROUND(SUM(CASE WHEN city = 'Chicago'
                   THEN share ELSE 0 END)/COUNT(CASE WHEN city = 'chicago'
                                                     THEN 1 ELSE 0 END), 2) AS "Average share in Chicago",
    ROUND(SUM(CASE WHEN NOT (city = 'Chicago')
                   THEN share ELSE 0 END)/COUNT(CASE WHEN NOT(city = 'chicago')
                                                     THEN 1 ELSE 0 END), 2) AS "Average share in other cities"
FROM accomplices
GROUP BY city;

 Average share in Chicago | Average share in other cities
--------------------------+-------------------------------
                     0.00 |                       8255.16
                  4221.41 |                          0.00
(2 rows)
