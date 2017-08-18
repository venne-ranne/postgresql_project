SELECT robber_id AS "RobberId", nickname AS "Nickname", (age-no_years) AS "Number of year not in prison"
FROM robbers
WHERE no_years > (age/2);
