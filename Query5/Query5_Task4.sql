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
