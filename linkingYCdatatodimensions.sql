-- Linking cleansed YC data to Dimensional model

if object_id('[Geography].[BoroughByYear]') is not null
drop table [Geography].[BoroughByYear]

SELECT 
	 P.*
	,ISNULL(BS.[CYbudget], 0) as Budget
	,ISNULL(BS.[CYstaffnos], 0) as StaffNos
	,CAST(ROUND(ISNULL(BS.[CYstaffnos], 0) / [PopUnder18], 2) as float) as StaffPerYouth
	,CAST(ROUND(ISNULL(BS.[CYstaffnos], 0) / [PopUnder18] * 1000, 2) as float) as StaffPer1000Youth
	,CAST(ROUND(ISNULL(BS.[CYbudget], 0) / [PopUnder18], 2) as float) as BudgetPerYouth
INTO [Geography].[BoroughByYear]
FROM [Geography].[Population] P -- 264 ROWS
INNER JOIN [Geography].[DimBorough] B
ON B.[BoroughID] = P.[BoroughID] -- 264 ROWS
LEFT JOIN [clean].[BudgetandStaffNos] BS
ON BS.[Borough] = B.[BoroughName] AND CAST(P.[Year] + '-01-01' AS DATE) = BS.[Year] -- 264 ROWS

--ALTER TABLE [Geography].[BoroughByYear] 
--ADD CONSTRAINT FK_BoroughtoBoroughYear FOREIGN KEY ([BoroughID])
--	REFERENCES [Geography].[DimBorough] ([BoroughID])

UPDATE [clean].[yclocations]
SET [BoroughName] = 'Kensington and Chelsea'
WHERE [BoroughName] = 'Kensington & Chelsea'

UPDATE [clean].[yclocations]
SET [BoroughName] = 'Kingston upon Thames'
WHERE [BoroughName] = 'Kingston'

UPDATE [clean].[yclocations]
SET [BoroughName] = 'Richmond upon Thames'
WHERE [BoroughName] = 'Richmond'

SELECT
	 B.[BoroughID]
	,Y.[YCName]
	,Y.[YCAddress]
	,Y.[YCPostCode]
	,Y.[cutsince2011flag]
	,Y.[Latitude]
	,Y.[Longitude]
	,Y.[Lsoa]
	,Y.[Parliamentary Constituency]
	,Y.[VolunteerYCSupportedByCouncilFlag]
INTO [YouthCentres].[DimYCs]
FROM [clean].[yclocations] Y -- 252 ROWS
INNER JOIN [Geography].[DimBorough] B
ON Y.[BoroughName] = B.[BoroughName] -- 252 ROWS

--ALTER TABLE [YouthCentres].[DimYCs]
--ADD CONSTRAINT FK_YCtoBoroughID FOREIGN KEY ([BoroughID])
--	REFERENCES [Geography].[DimBorough] ([BoroughID])