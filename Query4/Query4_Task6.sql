SELECT robber_id AS "RobberId",
       nickname AS "Nickname",
       description AS "Skill"
FROM has_skills
    NATURAL INNER JOIN robbers
    NATURAL INNER JOIN skills
ORDER BY has_skills.skill_id;
