
CREATE DATABASE DATA_NEW;
SELECT * FROM data_new.salaries;

SELECT EmployeeName,JobTitle FROM data_new.salaries;

SELECT COUNT(*) FROM data_new.salaries;

SELECT DISTINCT JobTitle FROM data_new.salaries;

SELECT JobTitle,Overtimepay FROM data_new.salaries WHERE Overtimepay>50000;

SELECT AVG(BasePay) as "Avg Base pay" FROM data_new.salaries; -- as means alias


SELECT EmployeeName,TotalPay FROM data_new.salaries 
ORDER BY TotalPay DESC
LIMIT  10;

SELECT EmployeeName,(BasePay+OvertimePay+OtherPay)/3 AS AVERAGE_BP_op_OTHERPAY FROM data_new.salaries;

SELECT EmployeeName,JobTitle FROM  data_new.salaries
WHERE JobTitle LIKE '%Manager%';

SELECT EmployeeName,JobTitle FROM data_new.salaries
WHERE JobTitle <> 'Manager';


SELECT * FROM data_new.salaries
WHERE TotalPay>=50000 and TotalPay<=75000;

SELECT * FROM data_new.salaries
WHERE TotalPay BETWEEN 50000 and 75000;


SELECT * FROM data_new.salaries
WHERE BasePay <5000 or TotalPay>100000;


SELECT * FROM data_new.salaries
WHERE TotalPayBenefits BETWEEN 125000 and 150000
and JobTitle LIKE '% Director%';


SELECT * FROM data_new.salaries
ORDER BY TotalPayBenefits DESC;


SELECT JobTitle,AVG(BasePay) as 'avgbasepay' FROM data_new.salaries
GROUP BY JobTitle
HAVING AVG(BasePay) >=100000
ORDER BY avgbasepay desc;

ALTER TABLE data_new.salaries
DROP COLUMN Notes;


UPDATE data_new.salaries 
SET BasePay=BasePay*1.1
WHERE JobTitle LIKE '%Manager%';


DELETE FROM data_new.salaries
WHERE OvertimePay=0;



















