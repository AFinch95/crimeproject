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

-- Creating Month Dimension
