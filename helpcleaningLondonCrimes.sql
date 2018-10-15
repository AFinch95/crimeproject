-- Checking lengths of all relevant columns to aid cleaning process

SELECT DISTINCT
	 LEN([Crime ID]) as [length of crimeID]
FROM [raw].[LondonCrimes]

SELECT DISTINCT
	 LEN([Month]) as [length of month]
FROM [raw].[LondonCrimes]

SELECT DISTINCT
	LEN([Longitude]) as [length of long]
FROM [raw].[LondonCrimes]

SELECT DISTINCT
	LEN([Latitude]) as [length of lat]
FROM [raw].[LondonCrimes]

SELECT DISTINCT
	LEN([LSOA code]) as [length of lsoa code]
FROM [raw].[LondonCrimes]

SELECT DISTINCT
	 max(LEN([LSOA name])) as [max length of lsoa name]
	,min(LEN([LSOA name])) as [min length of lsoa name]
FROM [raw].[LondonCrimes]

SELECT DISTINCT
	 max(LEN([Crime type])) as [max length of crime type]
	,min(LEN([Crime type])) as [min length of crime type]
FROM [raw].[LondonCrimes]

SELECT DISTINCT
	 max(LEN([Last outcome category] )) as [max length of outcome]
	,min(LEN([Last outcome category] )) as [min length of outcome]
FROM [raw].[LondonCrimes]