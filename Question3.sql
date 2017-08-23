QUESTION 3: Checking your Database [10 marks]
You are now expected to check that your database design enforces all the mentioned
consistency checks. Use SQL as a data manipulation language to perform the series of 8 tasks
listed below. For each task, record the feedback from PostgreSQL. If all is normal you should
receive error messages from PostgreSQL. For each task, briefly state which kind of constraint it
violates. If no error message is returned, then your database is probably not yet correct. You
should at least say what the constraint ought to be, even if you cannot implement it.
Please note: If you give names to your constraints, the error messages are more informative.
The tasks:
1. Insert the following tuples into the Banks table:
a. ('Loanshark Bank', 'Evanston', 100, 'very good')
INSERT INTO banks VALUES ('Loanshark Bank', 'Evanston', 100, 'very good');
ERROR:  duplicate key value violates unique constraint "banks_pkey"
DETAIL:  Key (bank_name, city)=(Loanshark Bank, Evanston) already exists.

b. ('EasyLoan Bank', 'Evanston', -5, 'excellent')
INSERT INTO banks VALUES ('EasyLoan Bank', 'Evanston', -5, 'excellent');
ERROR:  new row for relation "banks" violates check constraint "check_account_num"
DETAIL:  Failing row contains (EasyLoan Bank, Evanston, -5, excellent).

c. ('EasyLoan Bank', 'Evanston', 100, 'poor')
INSERT INTO banks VALUES ('EasyLoan Bank', 'Evanston', 100, 'poor');
ERROR:  new row for relation "banks" violates check constraint "check_security_input"
DETAIL:  Failing row contains (EasyLoan Bank, Evanston, 100, poor).


2. Insert the following tuple into the Skills table:
a. (20, 'Guarding')
INSERT INTO skills VALUES (20, 'Guarding');
ERROR:  duplicate key value violates unique constraint "must_be_different"
DETAIL:  Key (description)=(Guarding) already exists.

In the following two tasks we assume that there is a robber with Id 3, but no robber with Id 333.
3. Insert the following tuples into the Robbers table:
a. (1, 'Shotgun', 70, 0)
INSERT INTO robbers VALUES (1, 'Shotgun', 70, 0);
ERROR:  duplicate key value violates unique constraint "robbers_pkey"
DETAIL:  Key (robber_id)=(1) already exists.

b. (333, 'Jail Mouse', 25, 35)
INSERT INTO robbers VALUES (333, 'Jail Mouse', 25, 35);
ERROR:  new row for relation "robbers" violates check constraint "check_prison_years"
DETAIL:  Failing row contains (333, Jail Mouse, 25, 35).

4. Insert the following tuples into the HasSkills table:
a. (333, 1, 1, 'B-')
INSERT INTO has_skills VALUES (333, 1, 1, 'B-');
ERROR:  insert or update on table "has_skills" violates foreign key constraint "has_skills_robber_id_fkey"
DETAIL:  Key (robber_id)=(333) is not present in table "robbers".

b. (3, 20, 3, 'B+')
INSERT INTO has_skills VALUES (3, 20, 3, 'B+');
ERROR:  insert or update on table "has_skills" violates foreign key constraint "has_skills_skill_id_fkey"
DETAIL:  Key (skill_id)=(20) is not present in table "skills".

c. (1, 7, 1, 'A+')
INSERT INTO has_skills VALUES (1, 7, 1, 'A+');
ERROR:  new row for relation "has_skills" violates check constraint "check_preference_num"
DETAIL:  Failing row contains (1, 7, 1, A+).

d. (1, 2, 0, 'A')
INSERT INTO has_skills VALUES (1, 2, 0, 'A');
ERROR:  new row for relation "has_skills" violates check constraint "check_preference_num"
DETAIL:  Failing row contains (1, 2, 0, A ).

5. Insert the following tuple into the Robberies table:
a. ('NXP Bank', 'Chicago', '2009-01-08', 1000)
INSERT INTO robberies VALUES ('NXP Bank', 'Chicago', '2009-01-08', 1000);
ERROR:  duplicate key value violates unique constraint "robberies_pkey"
DETAIL:  Key (bank_name, city, robbery_date)=(NXP Bank, Chicago, 2009-01-08) already exists.

6. Delete the following tuples from the Banks table:
a. ('PickPocket Bank', 'Evanston', 2000, 'very good')
DELETE FROM banks WHERE bank_name = 'PickPocket Bank' AND city = 'Evanston' AND no_accounts = 2000 AND security = 'very good';
ERROR:  update or delete on table "banks" violates foreign key constraint "robberies_bank_name_fkey" on table "robberies"
DETAIL:  Key (bank_name, city)=(PickPocket Bank, Evanston) is still referenced from table "robberies".

b. ('Outside Bank', 'Chicago', 5000, 'good')
DELETE FROM banks WHERE bank_name = 'Outside Bank' AND city = 'Chicago' AND no_accounts = 5000 AND security = 'good';
DELETE 1


In the following two tasks we assume that Al Capone has the robber Id 1. If Al Capone has a
different Id in your database then please change the first entry in the following two tuples to be
your Id of Al Capone.
7. Delete the following tuple from the Robbers table:
a. (1, 'Al Capone', 31, 2).
DELETE FROM robbers WHERE robber_id = 1 AND nickname = 'Al Capone' AND age = 31 AND no_years = 2;
ERROR:  update or delete on table "robbers" violates foreign key constraint "has_accounts_robber_id_fkey" on table "has_accounts"
DETAIL:  Key (robber_id)=(1) is still referenced from table "has_accounts".

8. Delete the following tuple from the Skills table:
a. (1, 'Driving')
DELETE FROM skills WHERE skill_id = 1 AND description = 'Driving';
DELETE 0
There is not error thrown and no tuple in table is deleted as there is no matching tuple with values(1, 'Driving').

Your answer to Question 3 should include your SQL statements for each task, the feedback
from PostgreSQL, and the constraint that has been violated in case of an error message.
