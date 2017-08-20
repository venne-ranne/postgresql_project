----- Single nested SQL query for task 1 -----
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
