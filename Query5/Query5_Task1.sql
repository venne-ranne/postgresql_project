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
