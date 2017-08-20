SELECT robber_id AS "RobberId",
       nickname AS "Nickname",
       SUM(share) AS "Total Earning"
FROM accomplices
    NATURAL INNER JOIN robbers
GROUP BY robber_id, nickname
HAVING SUM(share) > 30000.00
ORDER BY SUM(share) DESC;
