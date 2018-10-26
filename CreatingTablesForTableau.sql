SELECT * FROM [YouthCentres].[DimYCs] WHERE [cutsince2011flag] NOT IN (0, 1)

UPDATE [YouthCentres].[DimYCs]
SET [cutsince2011flag] = 0 
WHERE [YCName] = 'Trinity@Bowes Youth project'

CREATE VIEW VW_CrimesAndYCdatabyBoroughandYear AS(
SELECT DISTINCT
	 F.[CrimeID]
	,B.[BoroughName]
	,YC.[#YCsClosedinBorough]
	,YC.[#YCsInBorough]
	,CAST(M.[year] AS varchar(4)) as [Year]
	,COUNT(F.[CrimeID]) OVER (PARTITION BY B.[BoroughName], M.[year]) AS [NumCrimesByBoroughAndYear]
FROM [Fact].[FactTable] F						-- 8,214,388 ROWS
INNER JOIN [Geography].[DimGeo] G
ON F.[GeoID] = G.[GeoID]						-- 8,214,388 ROWS
INNER JOIN [Geography].[DimBorough] B
ON G.[BoroughID] = B.[BoroughID]				-- 8,214,388 ROWS
INNER JOIN [YouthCentres].[DimYCs] YC
ON YC.[BoroughID] = B.[BoroughID]				-- 8,214,388 ROWS
INNER JOIN [Month].[DimMonth] M
ON F.[MonthID] = M.[MonthID]					-- 8,214,388 ROWS
INNER JOIN [Geography].[BoroughByYear] BBY
ON CAST(M.[year] AS varchar(4)) = BBY.[Year]	-- 6,715,453 ROWS (this removes all crimes not recorded in 2018)
)

-- Creating new column summing the number of closed youth centres and the number of youth centres per borough
SELECT 
	 *
	,SUM(CAST([cutsince2011flag] AS TINYINT)) OVER (PARTITION BY [BoroughID]) AS #YCsClosedinBorough
	,COUNT([YCName]) OVER (PARTITION BY [BoroughID]) as #YCsInBorough
INTO [YouthCentres].[DimYCs2]
FROM [YouthCentres].[DimYCs]

DROP TABLE [YouthCentres].[DimYCs]

EXEC SP_RENAME 'YouthCentres.DimYCs', 'DimYCs'

ALTER TABLE [YouthCentres].[DimYCs]
ADD CONSTRAINT FK_YCtoBoroughonID FOREIGN KEY ([BoroughID])
	REFERENCES [Geography].[DimBorough] ([BoroughID])


SELECT DISTINCT
	 B.[BoroughName]
	,M.[year]
	,ROUND(1000 * CAST(COUNT(F.[CrimeID]) OVER (PARTITION BY B.[BoroughName], M.[year]) AS BIGINT) / cast(BBY.[TotalPop] as float), 2)  as NumofCrimesPer1000People 
INTO [analysis].[CrimeCountPer1000PeopleByBoroughByYear]
FROM [Fact].[FactTable] F
INNER JOIN [Month].[DimMonth] M
	ON M.[MonthID] = F.[MonthID]
INNER JOIN [Geography].[DimGeo] G
	ON G.[GeoID] = F.[GeoID]
INNER JOIN [Geography].[DimBorough] B
	ON B.[BoroughID] = G.[BoroughID]
INNER JOIN [Geography].[BoroughByYear] BBY
	ON B.[BoroughID] = BBY.[BoroughID]
	AND BBY.[Year] = M.[year]
INNER JOIN [YouthCentres].[DimYCs] YC
	ON YC.[BoroughID] = B.[BoroughID]
WHERE M.[year] in ('2011', '2012', '2013', '2014', '2015', '2016', '2017')


SELECT DISTINCT
	 B.[BoroughName]
	,BBY.[Year]
	,ISNULL(YC.[#YCsClosedinBorough], 0) as #YCsClosedinBorough
	,ISNULL(YC.[#YCsInBorough], 0) as #YCsInBorough
INTO [analysis].[YCsByBoroughByYear]
FROM [YouthCentres].[DimYCs] YC
FULL OUTER JOIN [Geography].[DimBorough] B
	ON YC.[BoroughID] = B.[BoroughID]
INNER JOIN [Geography].[BoroughByYear] BBY
	ON BBY.[BoroughID] = B.[BoroughID]
WHERE BBY.[Year] <> 2010

ALTER TABLE [Month].[DimMonth] ALTER COLUMN [year] VARCHAR(4)

SELECT
	 B.[BoroughName]
	,M.[year]
	,CT.[CrimeTypeBin]
	,COUNT(DISTINCT F.[CrimeID]) as CrimeNumbersByCTBoroughYear
INTO [analysis].[CrimesByBoroughYearCT]
FROM [Fact].[FactTable] F
INNER JOIN [Month].[DimMonth] M
	ON M.[MonthID] = F.[MonthID]
INNER JOIN [Geography].[DimGeo] G
	ON G.[GeoID] = F.[GeoID]
INNER JOIN [Geography].[DimBorough] B
	ON B.[BoroughID] = G.[BoroughID]
INNER JOIN [CrimeType].[DimCrimeType] CT
	ON CT.[CrimeTypeID] = F.[CrimeTypeID]
WHERE M.[year] in ('2011', '2012', '2013', '2014', '2015', '2016', '2017')
GROUP BY B.[BoroughName], CT.[CrimeTypeBin], M.[year]

SELECT
	 B.[BoroughName]
	,M.[mnth]
	,M.[year]
	,CT.[CrimeTypeBin]
	,COUNT(DISTINCT F.[CrimeID]) as CrimeNumbersByCTBoroughYear
INTO [analysis].[CrimesByBoroughMonthYearCT]
FROM [Fact].[FactTable] F
INNER JOIN [Month].[DimMonth] M
	ON M.[MonthID] = F.[MonthID]
INNER JOIN [Geography].[DimGeo] G
	ON G.[GeoID] = F.[GeoID]
INNER JOIN [Geography].[DimBorough] B
	ON B.[BoroughID] = G.[BoroughID]
INNER JOIN [CrimeType].[DimCrimeType] CT
	ON CT.[CrimeTypeID] = F.[CrimeTypeID]
WHERE M.[year] in ('2011', '2012', '2013', '2014', '2015', '2016', '2017')
GROUP BY B.[BoroughName], CT.[CrimeTypeBin], M.[mnth], M.[year]

SELECT 
	 B.[BoroughName]
	,BBY.[Year]
	,YC.[#YCsClosedinBorough]
	,YC.[#YCsInBorough]
	,BBY.[PopUnder18]
	,BBY.[TotalPop]
	,BBY.[Budget]
	,BBY.[StaffNos]
	,BBY.[NumberOfYCs]
INTO [analysis].[YCData]
FROM [YouthCentres].[DimYCs] YC
INNER JOIN [Geography].[DimBorough] B
	ON B.[BoroughID] = YC.[BoroughID] 
INNER JOIN [Geography].[BoroughByYear] BBY
	ON BBY.[BoroughID] = B.[BoroughID]

SELECT
	 B.[BoroughName]
	,B.[SpatialObject]
	,YC.[Latitude]
	,YC.[Longitude]
	,YC.[cutsince2011flag]
FROM [YouthCentres].[DimYCs] YC
RIGHT JOIN [Geography].[DimBorough] B
ON YC.[BoroughID] = B.[BoroughID]

ALTER TABLE [YouthCentres].[DimYCs] ALTER COLUMN [Longitude] FLOAT
ALTER TABLE [YouthCentres].[DimYCs] ALTER COLUMN [Latitude] FLOAT

select distinct [BoroughName] from [Geography].[DimBorough]

SELECT 
	 B.[BoroughID]
	,BBY.[BoroughCode]
	,BBY.[Year]
	,BBY.[PopUnder18]
	,BBY.[TotalPop]
	,BBY.[Budget]
	,BBY.[StaffNos]
	,BBY.[StaffPerYouth]
	,BBY.[StaffPer1000Youth]
	,BBY.[BudgetPerYouth]
	,YC.[NumberOfYCs]
INTO [Geography].[BoroughByYear2]
FROM [clean].[NumberOfYCs] YC
INNER JOIN [Geography].[DimBorough] B
ON B.[BoroughName] = YC.[BoroughName]
INNER JOIN [Geography].[BoroughByYear] BBY
ON BBY.[BoroughID] = B.[BoroughID]
AND LEFT(YC.[Year] ,4) = BBY.[Year]

ALTER SCHEMA TRASH TRANSFER [Geography].[BoroughByYear]

EXEC SP_RENAME '[Geography].[BoroughByYear2]', 'BoroughByYear'

ALTER TABLE [Geography].[BoroughByYear]
ADD CONSTRAINT FK_BOROUGHBYYEARTOBOROUGHONID FOREIGN KEY ([BoroughID])
	REFERENCES [Geography].[DimBorough] ([BoroughID])

SELECT
	 B.[BoroughName]
	,B.[SpatialObject]
	,YC.[Latitude]
	,YC.[Longitude]
	,ISNULL(CAST(YC.[cutsince2011flag] AS SMALLINT),0) AS CUTFLAG
	,CASE 
		WHEN CHARINDEX('(', YC.[YCName]) <= 0 THEN ISNULL(YC.[YCName], '')
		ELSE ISNULL(LEFT(YC.[YCName], CHARINDEX('(', YC.[YCName]) - 2) , '')
	END AS YCNAME
--INTO [analysis].[Geo]
FROM [YouthCentres].[DimYCs] YC
RIGHT JOIN [Geography].[DimBorough] B
ON YC.[BoroughID] = B.[BoroughID]
WHERE [Latitude] > 51.47 AND [Latitude] < 51.48
AND [Longitude] < -0.143 AND [Longitude] > -0.144

DELETE FROM [analysis].[Geo]
WHERE YCNAME = 'Limehouse Youth Centre' AND [CUTFLAG] = 0

UPDATE [analysis].[Geo]
SET [Longitude] = -0.14315
WHERE [YCNAME] = 'Heathbrook Youth Club'

[analysis].[CrimesByBoroughMonthYearCT]