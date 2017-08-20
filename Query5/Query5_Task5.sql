----- Single nested SQL query for task 5 -----
SELECT chicago.average AS "Average share in Chicago", others.average AS "Average share in other cities"
FROM (SELECT ROUND((SUM(share)/COUNT(robber_id)), 2) AS "average"
      FROM accomplices
      WHERE accomplices.city = 'Chicago') AS chicago,
     (SELECT ROUND((SUM(share)/COUNT(robber_id)), 2) AS "average"
      FROM accomplices
      WHERE NOT(accomplices.city = 'Chicago')) AS others;


----- EXTRAS: Other approach for task 5 -----
SELECT
    ROUND(SUM(CASE WHEN city = 'Chicago'
                   THEN share ELSE 0 END)/COUNT(CASE WHEN city = 'chicago'
                                                     THEN 1 ELSE 0 END), 2) AS "Average share in Chicago",
    ROUND(SUM(CASE WHEN NOT (city = 'Chicago')
                   THEN share ELSE 0 END)/COUNT(CASE WHEN NOT(city = 'chicago')
                                                     THEN 1 ELSE 0 END), 2) AS "Average share in other cities"
FROM accomplices
GROUP BY city;
