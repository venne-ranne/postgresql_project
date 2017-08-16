QUESTION 4: Simple Database Queries [24 marks]
You are now expected to use SQL as a query language to retrieve data from the database.
Perform the series of 8 tasks listed below. For each task, record the answer from PostgreSQL.
The tasks:
1. Retrieve BankName and Security for all banks in Chicago that have more than 9000
accounts. [3 marks]
SELECT bank_name AS "BankName", security AS "Security" FROM banks WHERE city = 'Chicago';
    BankName     | Security
-----------------+-----------
 NXP Bank        | very good
 Loanshark Bank  | excellent
 Inter-Gang Bank | excellent
 Penny Pinchers  | weak
 Dollar Grabbers | very good
 PickPocket Bank | weak
 Hidden Treasure | excellent
 Bad Bank        | weak
 Outside Bank    | good
(9 rows)



2. Retrieve BankName of all banks where Calamity Jane has an account. The answer
should list every bank at most once. [3 marks]
SELECT DISTINCT bank_name AS "BankName"
FROM has_accounts
WHERE robber_id = (SELECT robber_id
                   FROM robbers
                   WHERE nickname = 'Calamity Jane');
    BankName
-----------------
 Bad Bank
 Dollar Grabbers
 PickPocket Bank
(3 rows)



3. Retrieve BankName and City of all bank branches that have no branch in Chicago. The
answer should be sorted in increasing order of the number of accounts. [3 marks]
SELECT bank_name AS "BankName", city AS "City"
FROM banks
WHERE EXISTS (SELECT DISTINCT bank_name, city FROM banks AS "other_banks" WHERE NOT(other_banks.city = 'Chicago'))
ORDER BY no_accounts ASC;

SELECT *
FROM banks
WHERE city NOT IN ('Pear', 'Banana', 'Bread');



4. Retrieve BankName and City of the first bank branch that was ever robbed by the gang.
[3 marks]
5. Retrieve RobberId, Nickname and individual total “earnings” of those robbers who have
earned more than $30,000 by robbing banks. The answer should be sorted in decreasing
order of the total earnings. [3 marks]
6. Retrieve the Descriptions of all skills together with the RobberId and NickName of all
robbers that possess this skill. The answer should be grouped by skill description.
[3 marks]
7. Retrieve RobberId, NickName, and the Number of Years in Prison for all robbers who
were in prison for more than three years. [3 marks]
8. Retrieve RobberId, Nickname and the Number of Years not spent in prison for all
robbers who spent more than half of their life in prison. [3 marks]
Your answer to Question 4 should include your SQL statement for each task, and the answer
from PostgreSQL.

Also, submit your SQL queries electronically. Submit each query (just SQL code) as a separate
.sql file. Name files in the following way: Query4_TaskX.sql, where X ranges from 1 to 8.
