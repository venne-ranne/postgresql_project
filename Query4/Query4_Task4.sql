SELECT DISTINCT bank_name AS "BankName", city AS "City"
FROM accomplices
WHERE robbery_date = (SELECT MIN(robbery_date)
                      FROM accomplices);
