CREATE VIEW total_earnings AS
SELECT robber_id AS "RobberId", SUM(share) AS "Total Share", COUNT(share) AS "# of Robberies"
FROM accomplices
GROUP BY robber_id
ORDER BY SUM(SHAre) DESC;

CREATE VIEW zero_prison_year AS
SELECT nickname AS "Nickname", no_years
FROM robbers
WHERE no_years = 0;
