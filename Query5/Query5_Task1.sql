----- Stepwise approach for task 1 -----
CREATE VIEW total_robberies AS
SELECT nickname, COUNT(robber_id) AS total, SUM(share) AS share
FROM robbers
    NATURAL INNER JOIN accomplices
GROUP BY robber_id
HAVING robbers.no_years = 0
ORDER BY SUM(share) DESC;

CREATE VIEW avg_robberies AS
SELECT ROUND(AVG(total), 0) AS avg_robberies
FROM total_robberies;

CREATE VIEW most_active_robbers AS
SELECT total_robberies.nickname AS "Nickname"
FROM total_robberies
    NATURAL INNER JOIN avg_robberies
WHERE (total > avg_robberies);


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
