-- Stepwise approach
SELECT banks.security AS "Security",
       COUNT(*) AS "Total # of robberies",
       ROUND((SUM(amount)/ COUNT(*)), 2) AS "Average amount of money"
FROM banks
    INNER JOIN robberies ON banks.bank_name = robberies.bank_name AND
                            banks.city = robberies.city
GROUP BY banks.security;


-- Nested SQL query
SELECT bank_robberies.security AS "Security",
       COUNT(*) AS "Total # of robberies",
       ROUND((SUM(amount)/ COUNT(*)), 2) AS "Average amount of money"
FROM (SELECT banks.bank_name, banks.city, banks.security, robberies.amount
      FROM robberies, banks
      WHERE banks.bank_name = robberies.bank_name AND
            banks.city = robberies.city) AS bank_robberies
GROUP BY bank_robberies.security;
