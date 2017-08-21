SELECT DISTINCT banks.security AS "Security",
                skills.description AS "Description",
                banks.nickname AS "Nickname"
FROM (SELECT DISTINCT security, nickname, robber_id
      FROM accomplices
        NATURAL INNER JOIN banks
        NATURAL INNER JOIN robbers) AS banks,
     (SELECT DISTINCT skill_id, description, robber_id
      FROM skills
        NATURAL INNER JOIN has_skills) AS skills
WHERE banks.robber_id = skills.robber_id
ORDER BY banks.security;
