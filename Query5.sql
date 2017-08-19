


SELECT (SELECT nickname FROM robbers WHERE accomplices.robber_id = robbers.robber_id) AS "Nickname"
FROM accomplices, robbers
GROUP BY accomplices.robber_id
HAVING COUNT(robber_id) > (SELECT (COUNT(*)/COUNT(DISTINCT accomplices.robber_id)) FROM accomplices)
       AND (SELECT no_years FROM robbers WHERE robber_id = robbers.robber_id) = 0
ORDER BY SUM(accomplices.share) DESC;


SELECT (SELECT nickname FROM robbers WHERE accomplices.robber_id = robbers.robber_id) AS "Nickname"
FROM accomplices
GROUP BY accomplices.robber_id
HAVING (COUNT(accomplices.robber_id) > (SELECT (COUNT(*)/COUNT(DISTINCT accomplices.robber_id)) FROM accomplices))
       AND (SELECT no_years FROM robbers WHERE accomplices.robber_id = robbers.robber_id) = 0
ORDER BY SUM(accomplices.share) DESC;

SELECT (SELECT nickname FROM robbers WHERE accomplices.robber_id = robbers.robber_id) AS "Nickname"
FROM accomplices
GROUP BY accomplices.robber_id
HAVING (COUNT(accomplices.robber_id) > get_avg_robberies())
       AND (SELECT no_years FROM robbers WHERE accomplices.robber_id = robbers.robber_id) = 0
ORDER BY SUM(accomplices.share) DESC;


QUESTION 5: Complex Database Queries [35 marks]
You are again expected to use SQL as a query language to retrieve data from the database.
Perform the series of 5 tasks listed below. For each task, you must construct SQL queries in
two ways: stepwise, and as a single nested SQL query.
The stepwise approach of computing complex queries consists of a sequence of basic (not
nested) SQL queries. The results of each query must be put into a virtual or a materialised view
(with the CREATE VIEW … AS SELECT … command, or the CREATE TABLE … AS
SELECT … command). The output of the last query should be the requested result. The first
query in the sequence uses the base relations as input. Each subsequent query in the sequence
may use the base relations and/or the intermediate results of the preceding views as input.

1. The police department wants to know which robbers are most active, but were never
penalised. Construct a view that contains the Nicknames of all robbers who participated in
more robberies than the average, but spent no time in prison. The answer should be sorted
in decreasing order of the individual total “earnings” of the robbers. [7 marks]

CREATE FUNCTION get_avg_robberies() RETURNS int AS
$max$
    DECLARE
        result int;
    BEGIN
        SELECT COUNT(*)/COUNT(DISTINCT accomplices.robber_id)
        FROM accomplices INTO result;
        RETURN result;
    END;
$max$
LANGUAGE plpgsql;

-- Stepwise approach (with using the function get_avg_robberies)
CREATE VIEW most_active_robbers AS
SELECT robbers.nickname AS "Nickname"
FROM accomplices
    INNER JOIN robbers ON robbers.robber_id = accomplices.robber_id
GROUP BY robbers.robber_id
HAVING (COUNT(accomplices.robber_id) > get_avg_robberies())
       AND (robbers.no_years = 0)
ORDER BY SUM(accomplices.share) DESC;

-- Nested SQL query
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



2. The police department wants to know whether bank branches with lower security levels are
more attractive for robbers than those with higher security levels. Construct a view
containing the Security level, the total Number of robberies that occurred in bank branches
of that security level, and the average Amount of money that was stolen during these
robberies. [7 marks]

-- Stepwise approach
SELECT banks.security AS "Security",
       COUNT(*) AS "Total # of robberies",
       ROUND((SUM(amount)/ COUNT(*)), 2) AS "Average amount of money"
FROM banks
    INNER JOIN robberies ON banks.bank_name = robberies.bank_name AND
                            banks.city = robberies.city
GROUP BY banks.security;
 Security  | Total # of robberies | Average amount of money
-----------+----------------------+-------------------------
 weak      |                    4 |                 2299.50
 good      |                    2 |                 3980.00
 excellent |                   12 |                39238.08
 very good |                    3 |                12292.43
(4 rows)

-- Nested SQL query
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



3. The police department wants to know which robbers are most likely to attack a particular
bank branch. Robbing bank branches with a certain security level might require certain
skills. For example, maybe every robbery of a branch with “excellent” security requires a
robber with “Explosives” skill. Construct a view containing Security level, Skill, and
Nickname showing for each security level all those skills that were possessed by some
participating robber in each robbery of a bank branch of the respective security level, and
the nicknames of all robbers who have that skill. [7 marks]

SELECT banks.security, skills.description, robbers.nickname
FROM has_skills
  inner join accomplices on has_skills.robber_id = accomplices.robber_id
  inner join skills on skills.skill_id = has_skills.skill_id
  inner join banks on accomplices.bank_name = banks.bank_name AND accomplices.city = banks.city
  inner join robbers on accomplices.robber_id = robbers.robber_id
GROUP BY banks.security, skills.description, robbers.nickname
ORDER BY banks.security;
security  |  description   |     nickname
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


4. The police department wants to increase security at those bank branches that are most
likely to be victims in the near future. Construct a view containing the BankName, the City,
and Security level of all bank branches that have not been robbed in the previous year, but
where plans for a robbery next year are known. The answer should be sorted in decreasing
order of the number of robbers who have accounts in that bank branch. [7 marks]

-- Stepwise approach
SELECT banks.bank_name AS "BankName",
       banks.city AS "City",
       banks.security AS "Security"
FROM banks
    LEFT JOIN robberies ON banks.bank_name = robberies.bank_name AND
                           banks.city = robberies.city
    INNER JOIN plans ON banks.bank_name = plans.bank_name AND
                        banks.city = plans.city
WHERE robberies.bank_name IS NULL
GROUP BY banks.bank_name, banks.city
ORDER BY banks.no_accounts DESC;
    BankName     |   City    | Security
-----------------+-----------+-----------
 Loanshark Bank  | Deerfield | very good
 Hidden Treasure | Chicago   | excellent
 Dollar Grabbers | Chicago   | very good
 PickPocket Bank | Deerfield | excellent
(4 rows)

-- Nested SQL query
SELECT target_banks.bank_name AS "BankName",
       target_banks.city AS "City",
       target_banks.security AS "Security"
FROM (SELECT DISTINCT plans.bank_name, plans.city, banks.security, banks.no_accounts
      FROM plans, banks
      WHERE banks.bank_name = plans.bank_name AND
            banks.city = plans.city AND
            NOT EXISTS (SELECT *
                        FROM robberies
                        WHERE banks.bank_name = robberies.bank_name AND
                              banks.city = robberies.city)) AS target_banks
ORDER BY target_banks.no_accounts DESC;
    BankName     |   City    | Security
-----------------+-----------+-----------
 Loanshark Bank  | Deerfield | very good
 Hidden Treasure | Chicago   | excellent
 Dollar Grabbers | Chicago   | very good
 PickPocket Bank | Deerfield | excellent
(4 rows)




5. The police department has a theory that bank robberies in Chicago are more profitable
than in any other city in their district. Construct a view that shows the average share of all
robberies in Chicago, and the average share of all robberies for that city (other than
Chicago) that observes the highest average share. The average share of a robbery is
computed based on the number of participants in that particular robbery. [7 marks]


FROM accomplices AS t1, accomplices AS t2



-- Nested SQL query
SELECT chicago.average AS "Average share in Chicago", others.average AS "Average share in other cities"
FROM (SELECT ROUND((SUM(share)/COUNT(DISTINCT robber_id)), 2) AS "average"
      FROM accomplices
      WHERE accomplices.city = 'Chicago') AS chicago,
     (SELECT ROUND((SUM(share)/COUNT(DISTINCT robber_id)), 2) AS "average"
      FROM accomplices
      WHERE NOT(accomplices.city = 'Chicago')) AS others;
 Average share in Chicago | Average share in other cities
--------------------------+-------------------------------
                  6595.96 |                      22158.58
(1 row)


SELECT SUM(accomplices.share) AS "Share", COUNT(DISTINCT accomplices.robber_id) AS "Average share in Chicago"
FROM accomplices
GROUP BY accomplices.city;

SELECT accomplices.robber_id, COUNT(accomplices.robber_id) AS "Average share in Chicago"
FROM accomplices
WHERE city = 'Evanston'
GROUP BY accomplices.robber_id;

SELECT sum(share)
FROM accomplices
WHERE city = 'Evanston'
GROUP BY accomplices.robber_id;




Your answer to Question 5 should include:
• A sequence of SQL statements for the basic queries and the views/tables you created,
and the output of the final query.
• A single nested SQL query, with its output from PostgreSQL (hopefully the same).
Also, submit your SQL nested queries electronically. Submit each nested query (just SQL
code) as a separate .sql file. Name files in the following way: Query5_TaskX.sql, where X
ranges from 1 to 5.
****************************************************************************
