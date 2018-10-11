-- Reducing number of crimes to only include crimes committed in a London LSOA and saving to new table

-- Creating table of London LSOAs only
if OBJECT_ID('[raw].[LondonLSOA]') is not null
drop table [raw].[LondonLSOA]

create table [raw].[LondonLSOA]
(LSOACode char(9) -- all LSOA codes have 9 chars from initial analysis
,LSOAName varchar(27) -- max LSOA name has 27 chars
)

-- Populating new table with London LSOAs from original data source
INSERT INTO [raw].[LondonLSOA]
SELECT *
FROM [dbo].[LondonLSOAcodes]

-- Creating table for all crimes committed in London 
if OBJECT_ID('[raw].[LondonCrimes]') is not null
drop table [raw].[LondonCrimes]

create table [raw].[LondonCrimes]
([Crime ID] varchar(500)                  -- keeping all as varchar(500) but will clean the data types later
,[Month] varchar(500)
,[Reported by] varchar(500)
,[Falls within] varchar(500)
,[Longitude] varchar(500)
,[Latitude] varchar(500)
,[Location] varchar(500)
,[LSOA code] varchar(500)
,[LSOA name] varchar(500)
,[Crime type] varchar(500)
,[Last outcome category] varchar(500)
,[Context] varchar(500)
)

-- Populating table with crimes in London
INSERT INTO [raw].[LondonCrimes]
SELECT
	 [Crime ID]
	,[Month]
	,[Reported by]
	,[Falls within]
	,[Longitude]
	,[Latitude]
	,[Location]
	,[LSOA code]
	,[LSOA name]
	,[Crime type]
	,[Last outcome category]
	,[Context]
FROM [raw].[crimedataraw] c
INNER JOIN [raw].[LondonLSOA] l -- Joining on LSOA code to exclude all the crimes committed outside of London
ON c.[LSOA code] = l.LSOACode