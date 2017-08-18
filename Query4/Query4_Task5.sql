SELECT robber_id AS "RobberId",
       (SELECT nickname
        FROM robbers
        WHERE robbers.robber_id = accomplices.robber_id) AS "Nickname",
       SUM(share) AS "Total Earning"
FROM accomplices
GROUP BY robber_id
HAVING SUM(share) > 30000.00
ORDER BY SUM(share) DESC;
