use crimeproject
go

-- Cleaning the LondonCrime data
SELECT
	   cast(ISNULL(NULLIF([Crime ID], ''), 'Missing') AS char(64)) as [PoliceCrimeID]
	  ,cast([Month] + '-01' as date) as [Month]
	  ,cast([Longitude] as decimal(8,6)) as [Longitude]
	  ,cast([Latitude] as decimal(8,6)) as [Latitude]
	  ,cast([LSOA code] as char(9)) as [LSOACode]
	  ,cast([LSOA name] as varchar(27)) as [LSOAName]
	  ,cast([Crime type] as varchar(28)) as [CrimeType]
	  ,cast(isnull(nullif([Last outcome category], ''), 'Missing') as varchar(51)) as [Outcome]
INTO [clean].[LondonCrimes] --8,214,388 rows
FROM [raw].[LondonCrimes]