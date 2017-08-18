SELECT robber_id AS "RobberId",
       (SELECT nickname
        FROM robbers
        WHERE robbers.robber_id = has_skills.robber_id) AS "Nickname",
       (SELECT description
        FROM skills
        WHERE skills.skill_id = has_skills.skill_id) AS "Skill"
FROM has_skills
ORDER BY has_skills.skill_id;
