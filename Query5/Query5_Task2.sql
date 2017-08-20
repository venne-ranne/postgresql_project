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

----- Single nested SQL query for task 2 -----
SELECT bank_robberies.security AS "Security",
       COUNT(*) AS "Total # of robberies",
       ROUND((SUM(amount)/ COUNT(*)), 2) AS "Average amount of money"
FROM (SELECT banks.bank_name, banks.city, banks.security, robberies.amount
      FROM robberies, banks
      WHERE banks.bank_name = robberies.bank_name AND
            banks.city = robberies.city) AS bank_robberies
GROUP BY bank_robberies.security;
