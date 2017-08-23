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
