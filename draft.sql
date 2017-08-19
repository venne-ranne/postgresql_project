SELECT banks.security AS "Security",
       COUNT(*) AS "Total # of robberies",
       ROUND((SUM(amount)/ COUNT(*)), 2) AS "Average amount of money"
FROM banks
    INNER JOIN robberies ON banks.bank_name = robberies.bank_name AND
                            banks.city = robberies.city
GROUP BY banks.security;

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
