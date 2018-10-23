USE CRIMEPROJECT;
--SELECT * FROM [clean].[BudgetAndStaffNos]

--CREATE TABLE clean.BoroughsandYears
-- Borough varchar60 
--,BoroughID int
--,[Year] date
--
if object_id('clean.BoroughsandYears') is not null
drop table clean.BoroughsandYears

SELECT 
	 cast(B.[BoroughName] as varchar(60)) Borough 
	,cast(P.[BoroughID] as int) BoroughID
	,cast(P.[Year] as date) [Year]
INTO clean.BoroughsandYears
FROM [Geography].[Population] P 
INNER JOIN [Geography].[DimBorough] B
ON P.[BoroughID] = B.[BoroughID]

begin tran
INSERT INTO clean.BoroughsandYears (Borough, BoroughID, [Year])
VALUES ('Barking and Dagenham', 7,'2018-01-01'), ('Barnet',26,'2018-01-01') ,('Bexley', 21,'2018-01-01'), ('Brent', 15,'2018-01-01'), ('Bromley', 33,'2018-01-01'),('Camden',16,'2018-01-01'),('City of London',25,'2018-01-01'),('Croydon',9,'2018-01-01'),('Ealing',1,'2018-01-01'),('Enfield',17,'2018-01-01'),('Greenwich',14,'2018-01-01'),('Hackney',28,'2018-01-01'),('Hammersmith and Fulham',22,'2018-01-01'),('Haringey',6,'2018-01-01'),('Harrow',30,'2018-01-01'),('Havering',8,'2018-01-01'),('Hillingdon',10,'2018-01-01'),('Hounslow',19,'2018-01-01'),('Islington',5,'2018-01-01'),('Kensington and Chelsea',13,'2018-01-01'),('Kingston upon Thames',23,'2018-01-01'),('Lambeth',29,'2018-01-01'),('Lewisham',4,'2018-01-01'),('Merton',11,'2018-01-01'),('Newham',27,'2018-01-01'),('Redbridge',32,'2018-01-01'),('Richmond upon Thames',20,'2018-01-01'),('Southwark',24,'2018-01-01'),('Sutton',12,'2018-01-01'),('Tower Hamlets',18,'2018-01-01'),('Waltham Forest',31,'2018-01-01'),('Wandsworth',2,'2018-01-01'),('Westminster',3,'2018-01-01')
; 

commit tran rollback tran

SELECT DISTINCT
B.[BoroughName], b.[BoroughID]
from [Geography].[DimBorough] B
order by [BoroughName]