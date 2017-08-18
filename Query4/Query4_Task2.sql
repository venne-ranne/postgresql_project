SELECT DISTINCT bank_name AS "BankName"
FROM has_accounts
WHERE robber_id = (SELECT robber_id
                   FROM robbers
                   WHERE nickname = 'Calamity Jane');
