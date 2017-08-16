CREATE VIEW total_earnings AS
SELECT robber_id AS "RobberId", SUM(share) AS "Total Share", COUNT(share) AS "# of Robberies"
FROM accomplices
GROUP BY robber_id
ORDER BY SUM(SHAre) DESC;

CREATE VIEW zero_prison_year AS
SELECT nickname AS "Nickname", no_years
FROM robbers
WHERE no_years = 0;

CREATE VIEW  AS
SELECT total_earnings *
FROM total_earnings
WHERE table_name = 'RobberId';

SELECT DISTINCT robbers.nickname AS "Nickname"
FROM robbers, accomplices
WHERE robbers.robber_id = accomplices.robber_id
  AND robbers.no_years = 0
  AND COUNT(robber_id) > COUNT(robber_id)/COUNT(DISTINCT robber_id)
ORDER BY SUM(share);


GROUP BY accomplices.robber_id

SELECT COUNT(robber_id)/COUNT(DISTINCT robber_id)
FROM accomplices;


SELECT SELECT nickname FROM robbers WHERE accomplices
FROM accomplices
WHERE robbers.robber_id = accomplices.robber_id
  AND robbers.no_years = 0
GROUP BY robber_id
ORDER BY SUM(accomplices.share);

SELECT DISTINCT accomplices.robber_id, (SELECT nickname FROM robbers WHERE robbers.robber_id = accomplices.robber_id)
FROM accomplices, robbers
WHERE robbers.robber_id = accomplices.robber_id
  AND robbers.no_years = 0
GROUP BY accomplices.robber_id;
