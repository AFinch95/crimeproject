-- Enriching Geo dimension with Borough Name

ALTER TABLE [Geography].[DimGeo]
ADD Borough varchar(22) 

UPDATE [Geography].[DimGeo]
SET Borough = LEFT([LSOAName], LEN([LSOAName]) - 5)