----- Stepwise approach for task 4 -----
CREATE VIEW never_been_robbed AS
SELECT banks.bank_name, banks.city, banks.security, banks.no_accounts
FROM banks
    LEFT JOIN robberies ON banks.bank_name = robberies.bank_name AND
                           banks.city = robberies.city
WHERE robberies.bank_name IS NULL
GROUP BY banks.bank_name, banks.city;

CREATE VIEW planned_robberies AS
SELECT banks.bank_name, banks.city
FROM banks
    INNER JOIN plans ON banks.bank_name = plans.bank_name AND
                        banks.city = plans.city
GROUP BY banks.bank_name, banks.city
ORDER BY banks.no_accounts DESC;

CREATE VIEW target_banks AS
SELECT bank_name AS "BankName", city AS "City", security AS "Security"
FROM planned_robberies
    NATURAL INNER JOIN never_been_robbed
ORDER BY no_accounts DESC;


----- Single nested SQL query for task 4 -----
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
