----- Single nested SQL query for task 3 -----
SELECT DISTINCT security AS "Security", description AS "Description", nickname AS "Nickname"
FROM accomplices
  NATURAL INNER JOIN has_skills
  NATURAL INNER JOIN skills
  NATURAL INNER JOIN banks
  NATURAL INNER JOIN robbers
ORDER BY security;
