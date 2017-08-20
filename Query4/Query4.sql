-- QUESTION 4: Simple Database Queries [24 marks]
-- You are now expected to use SQL as a query language to retrieve data from the database.
-- Perform the series of 8 tasks listed below. For each task, record the answer from PostgreSQL.
-- The tasks:
-- 1. Retrieve BankName and Security for all banks in Chicago that have more than 9000 accounts. [3 marks]
SELECT bank_name AS "BankName", security AS "Security"
FROM banks
WHERE city = 'Chicago' AND no_accounts > 9000;

    BankName     | Security
-----------------+-----------
 NXP Bank        | very good
 Loanshark Bank  | excellent
 Inter-Gang Bank | excellent
 Penny Pinchers  | weak
 Dollar Grabbers | very good
 PickPocket Bank | weak
 Hidden Treasure | excellent
(7 rows)


-- 2. Retrieve BankName of all banks where Calamity Jane has an account. The answer
-- should list every bank at most once. [3 marks]
SELECT DISTINCT bank_name AS "BankName"
FROM has_accounts
WHERE robber_id = (SELECT robber_id
                   FROM robbers
                   WHERE nickname = 'Calamity Jane');

    BankName
-----------------
 Dollar Grabbers
 Bad Bank
 PickPocket Bank
(3 rows)


-- 3. Retrieve BankName and City of all bank branches that have no branch in Chicago. The
-- answer should be sorted in increasing order of the number of accounts. [3 marks]
SELECT bank_name AS "BankName", city AS "City"
FROM banks
WHERE (SELECT subquery.bank_name
       FROM banks AS "subquery"
       WHERE subquery.city = 'Chicago' AND subquery.bank_name = banks.bank_name) IS NULL
ORDER BY no_accounts ASC;

    BankName    |   City
----------------+-----------
 Gun Chase Bank | Deerfield
 Bankrupt Bank  | Evanston
 Gun Chase Bank | Evanston
(3 rows)


-- 4. Retrieve BankName and City of the first bank branch that was ever robbed by the gang.[3 marks]
SELECT DISTINCT bank_name AS "BankName", city AS "City"
FROM accomplices
WHERE robbery_date = (SELECT MIN(robbery_date)
                      FROM accomplices);

    BankName    |   City
----------------+----------
 Loanshark Bank | Evanston
(1 row)


-- 5. Retrieve RobberId, Nickname and individual total “earnings” of those robbers who have
-- earned more than $30,000 by robbing banks. The answer should be sorted in decreasing
-- order of the total earnings. [3 marks]
SELECT robber_id AS "RobberId",
       nickname AS "Nickname",
       SUM(share) AS "Total Earning"
FROM accomplices
    NATURAL INNER JOIN robbers
GROUP BY robber_id, nickname
HAVING SUM(share) > 30000.00
ORDER BY SUM(share) DESC;

 RobberId |     Nickname      | Total Earning
----------+-------------------+---------------
        5 | Mimmy The Mau Mau |      70000.00
       15 | Boo Boo Hoff      |      61447.61
       16 | King Solomon      |      59725.80
       17 | Bugsy Siegel      |      52601.10
        3 | Lucky Luchiano    |      42667.00
       10 | Bonnie            |      40085.00
        1 | Al Capone         |      39486.00
        4 | Anastazia         |      39169.62
        8 | Clyde             |      31800.00
(9 rows)


-- 6. Retrieve the Descriptions of all skills together with the RobberId and NickName of all
-- robbers that possess this skill. The answer should be grouped by skill description.[3 marks]
SELECT robber_id AS "RobberId",
       nickname AS "Nickname",
       description AS "Skill"
FROM has_skills
    NATURAL INNER JOIN robbers
    NATURAL INNER JOIN skills
ORDER BY has_skills.skill_id;

 RobberId |     Nickname      |     Skill
----------+-------------------+----------------
       24 | Sonny Genovese    | Safe-Cracking
       11 | Meyer Lansky      | Safe-Cracking
        1 | Al Capone         | Safe-Cracking
       12 | Moe Dalitz        | Safe-Cracking
       24 | Sonny Genovese    | Explosives
        2 | Bugsy Malone      | Explosives
       23 | Lepke Buchalter   | Guarding
       17 | Bugsy Siegel      | Guarding
        4 | Anastazia         | Guarding
        9 | Calamity Jane     | Gun-Shooting
       21 | Waxey Gordon      | Gun-Shooting
       18 | Vito Genovese     | Cooking
       18 | Vito Genovese     | Scouting
        8 | Clyde             | Scouting
       20 | Longy Zwillman    | Driving
       23 | Lepke Buchalter   | Driving
       17 | Bugsy Siegel      | Driving
        5 | Mimmy The Mau Mau | Driving
        3 | Lucky Luchiano    | Driving
        7 | Dutch Schulz      | Driving
       19 | Mike Genovese     | Money Counting
       13 | Mickey Cohen      | Money Counting
       14 | Kid Cann          | Money Counting
       22 | Greasy Guzik      | Preaching
       10 | Bonnie            | Preaching
        1 | Al Capone         | Preaching
       24 | Sonny Genovese    | Lock-Picking
        3 | Lucky Luchiano    | Lock-Picking
        7 | Dutch Schulz      | Lock-Picking
        8 | Clyde             | Lock-Picking
       22 | Greasy Guzik      | Lock-Picking
        8 | Clyde             | Planning
        1 | Al Capone         | Planning
       15 | Boo Boo Hoff      | Planning
       16 | King Solomon      | Planning
        5 | Mimmy The Mau Mau | Planning
       18 | Vito Genovese     | Eating
        6 | Tony Genovese     | Eating
(38 rows)


-- 7. Retrieve RobberId, NickName, and the Number of Years in Prison for all robbers who
-- were in prison for more than three years. [3 marks]
SELECT robber_id AS "RobberId",
       nickname AS "Nickname",
       no_years AS "Total prison years"
FROM robbers
WHERE no_years > 3;
 RobberId |    Nickname    | Total prison years
----------+----------------+--------------------
        2 | Bugsy Malone   |                 15
        3 | Lucky Luchiano |                 15
        4 | Anastazia      |                 15
        6 | Tony Genovese  |                 16
        7 | Dutch Schulz   |                 31
       11 | Meyer Lansky   |                  6
       15 | Boo Boo Hoff   |                 13
       16 | King Solomon   |                 43
       17 | Bugsy Siegel   |                 13
       20 | Longy Zwillman |                  6
(10 rows)


-- 8. Retrieve RobberId, Nickname and the Number of Years not spent in prison for all
-- robbers who spent more than half of their life in prison. [3 marks]
SELECT robber_id AS "RobberId",
       nickname AS "Nickname",
       (age-no_years) AS "Number of year not in prison"
FROM robbers
WHERE no_years > (age/2);

 RobberId |   Nickname    | Number of year not in prison
----------+---------------+------------------------------
        6 | Tony Genovese |                           12
       16 | King Solomon  |                           31
(2 rows)


-- Your answer to Question 4 should include your SQL statement for each task, and the answer
-- from PostgreSQL. Also, submit your SQL queries electronically. Submit each query (just SQL code) as a separate
-- .sql file. Name files in the following way: Query4_TaskX.sql, where X ranges from 1 to 8.
