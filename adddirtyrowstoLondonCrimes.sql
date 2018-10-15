-- Find all crimes entered incorrectly (every column after and including LSOA code in subsequent column
SELECT *
FROM [raw].[LondonCrimes]
--Add incorrectly entered crimes that occured in London to LondonCrimes table
UNION ALL
SELECT 
	 cr.[Crime ID]
	,cr.[Month]
	,cr.[Reported by]
	,cr.[Falls within]
	,cr.[Longitude]
	,cr.[Latitude]
	,cr.[Location]
-- Add correct LSOA code and name from LondonLSOA table
	,ls.[LSOACode] as [LSOA code]
	,ls.[LSOAName] as [LSOA name]
-- Move remaining data left one column and add blanks to Context column (as all of them are)
	,cr.[Last outcome category] as [Crime type]
	,cr.[Context] as [Last outcome category]
	,REPLACE(cr.[Last outcome category], cr.[Last outcome category], '') as [Context]
-- Join LondonLSOA table on next row to LSOA code (i.e. LSOA name) with LSOA code from LondonLSOA table
FROM [trash].[crimedataraw] cr
INNER JOIN [raw].[LondonLSOA] ls
ON cr.[LSOA name] = ls.LSOACode
WHERE 1=1
-- Where LSOA code is not of usual LSOA code format (i.e. not of 9 characters)
	AND len([LSOA code]) <> 9
	AND len([LSOA code]) > 0