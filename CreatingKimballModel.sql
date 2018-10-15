-- Creating Kimball Model by creating dimensional tables
-- Creating Crime Type Dimension
if OBJECT_ID('[CrimeType].[DimCrimeType]') is not null
begin 
drop table [CrimeType].[DimCrimeType]
end

SELECT DISTINCT
	 [CrimeType]
INTO [CrimeType].[DimCrimeType]
FROM [clean].[LondonCrimes]

-- Adding CrimeType ID
ALTER TABLE [CrimeType].[DimCrimeType]
add CrimeTypeID int not null identity primary key

-- Creating Outcome Dimension
if OBJECT_ID('[Outcome].[DimOutcome]') is not null
begin
drop table [Outcome].[DimOutcome]
end

SELECT DISTINCT
	 [Outcome]
INTO [Outcome].[DimOutcome]
FROM [clean].[LondonCrimes]

-- Adding CrimeType ID
ALTER TABLE [Outcome].[DimOutcome]
add OutcomeID int not null identity primary key

-- Creating Geography Dimension
if OBJECT_ID('[Geography].[DimGeo]') is not null
begin
drop table [Geography].[DimGeo]
end

SELECT DISTINCT
	  [LSOACode]
	 ,[LSOAName]
INTO [Geography].[DimGeo]
FROM [clean].[LondonCrimes]

-- Adding GeoID
ALTER TABLE [Geography].[DimGeo]
add GeoID int not null identity primary key

-- Creating Month Dimension using recursive CTE

if OBJECT_ID('[Month].[DimMonth]') is not null
begin
drop table [Month].[DimMonth]
end

;WITH CTE 
AS(
SELECT
	 CAST('2010-12-01' as date) as dt
	,DATEPART(mm, CAST('2010-12-01' as date)) as mnth
	,DATENAME(mm, CAST('2010-12-01' as date)) as mnthname
	,DATEPART(yy, CAST('2010-12-01' as date)) as [year]
	,CASE
		WHEN month(CAST('2010-12-01' as date)) in (12, 1, 2) THEN 'Winter'
		WHEN month(CAST('2010-12-01' as date)) in (3, 4, 5) THEN 'Spring'
		WHEN month(CAST('2010-12-01' as date)) in (6, 7, 8) THEN 'Summer'
		WHEN month(CAST('2010-12-01' as date)) in (9, 10, 11) THEN 'Autumn'
	END as season
UNION ALL
SELECT
	 DATEADD(MM, 1, dt)
	,DATEPART(mm, DATEADD(MM, 1, dt))
	,DATENAME(mm, DATEADD(MM, 1, dt))
	,DATEPART(yy, DATEADD(MM, 1, dt))
	,CASE
		WHEN month(DATEADD(MM, 1, dt)) in (12, 1, 2) THEN 'Winter'
		WHEN month(DATEADD(MM, 1, dt)) in (3, 4, 5) THEN 'Spring'
		WHEN month(DATEADD(MM, 1, dt)) in (6, 7, 8) THEN 'Summer'
		WHEN month(DATEADD(MM, 1, dt)) in (9, 10, 11) THEN 'Autumn'
	END
FROM CTE 
WHERE DATEADD(MM, 1, dt) <= DATEADD(MM, 1, GETDATE())
)
SELECT *
INTO [Month].[DimMonth]
FROM CTE
OPTION (maxrecursion 0)

-- Adding MonthID
ALTER TABLE [Month].[DimMonth]
add MonthID int not null identity primary key

-- Create Fact Table

if OBJECT_ID('[fact].[facttable]') is not null
begin
drop table [fact].[facttable]
end
SELECT
	 lc.[CrimeID]
	,dm.[MonthID]
	,dg.[GeoID]
	,dct.[CrimeTypeID]
	,do.[OutcomeID]
INTO [fact].[facttable]
FROM [clean].[LondonCrimes] lc												-- 8,214,388 rows
INNER JOIN [Month].[DimMonth] dm ON lc.[Month] = dm.dt						-- 8,214,388 rows
INNER JOIN [Geography].[DimGeo] dg ON lc.LSOACode = dg.LSOACode				-- 8,214,388 rows
INNER JOIN [CrimeType].[DimCrimeType] dct ON lc.CrimeType = dct.CrimeType	-- 8,214,388 rows
INNER JOIN [Outcome].[DimOutcome] do ON lc.Outcome = do.Outcome				-- 8,214,388 rows 

ALTER TABLE [Fact].[facttable]
ADD CONSTRAINT FK_MonthID FOREIGN KEY (MonthID)
	REFERENCES [Month].[DimMonth] ([MonthID])

ALTER TABLE [Fact].[facttable]
ADD CONSTRAINT FK_GeoID FOREIGN KEY (GeoID)
	REFERENCES [Geography].[DimGeo] ([GeoID])

ALTER TABLE [Fact].[facttable]
ADD CONSTRAINT FK_CrimeTypeID FOREIGN KEY ([CrimeTypeID])
	REFERENCES [CrimeType].[DimCrimeType] ([CrimeTypeID])

ALTER TABLE [Fact].[facttable]
ADD CONSTRAINT FK_OutcomeID FOREIGN KEY ([OutcomeID])
	REFERENCES [Outcome].[DimOutcome] ([OutcomeID])