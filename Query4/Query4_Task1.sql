SELECT bank_name AS "BankName", security AS "Security"
FROM banks
WHERE city = 'Chicago' AND no_accounts > 9000;
