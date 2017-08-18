SELECT bank_name AS "BankName", city AS "City"
FROM banks
WHERE (SELECT subquery.bank_name
       FROM banks AS "subquery"
       WHERE subquery.city = 'Chicago' AND subquery.bank_name = banks.bank_name) IS NULL
ORDER BY no_accounts ASC;
