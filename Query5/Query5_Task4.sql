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
