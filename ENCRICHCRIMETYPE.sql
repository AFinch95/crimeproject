-- Enrich Crime Type Dim

if object_id('[CrimeType].[DimCrimeType2]') is not null
drop table [CrimeType].[DimCrimeType2]
SELECT 
	 *
	,CASE
		WHEN [CrimeType] = 'Bicycle theft'					THEN 'Theft'
		WHEN [CrimeType] = 'Other theft'					THEN 'Theft'
		WHEN [CrimeType] = 'Theft from the person'			THEN 'Theft'
		WHEN [CrimeType] = 'Public order'					THEN 'Public Disorder and Weapon Offences'
		WHEN [CrimeType] = 'Public disorder and weapons'	THEN 'Public Disorder and Weapon Offences'
		WHEN [CrimeType] = 'Possession of weapons'			THEN 'Public Disorder and Weapon Offences'
		WHEN [CrimeType] = 'Violent crime'					THEN 'Violent and Sexual Offences'
		WHEN [CrimeType] = 'Violence and sexual offences'	THEN 'Violent and Sexual Offences'
		WHEN [CrimeType] = 'Drugs'							THEN 'Drugs'
		WHEN [CrimeType] = 'Shoplifting'					THEN 'Theft'
		WHEN [CrimeType] = 'Anti-social behaviour'			THEN 'Anti-Social Behaviour'
		WHEN [CrimeType] = 'Burglary'						THEN 'Theft'
		WHEN [CrimeType] = 'Robbery'						THEN 'Theft'
		WHEN [CrimeType] = 'Vehicle crime'					THEN 'Vehicle Crime'
		WHEN [CrimeType] = 'Criminal damage and arson'		THEN 'Criminal Damage and Arson'
		WHEN [CrimeType] = 'Other crime'					THEN 'Other'
	 END as CrimeTypeBin
INTO [CrimeType].[DimCrimeType2]
FROM [CrimeType].[DimCrimeType]

alter schema [trash] transfer [CrimeType].[DimCrimeType]

exec sp_rename 'CrimeType.DimCrimeType2', 'DimCrimeType'

ALTER TABLE [CrimeType].[DimCrimeType] 
ADD CONSTRAINT PK_CRIMETYPEIDTOFACT PRIMARY KEY ([CrimeTypeID])

ALTER TABLE [Fact].[FactTable]
ADD CONSTRAINT FK_CRIMETYPEIDTODIM FOREIGN KEY ([CrimeTypeID])
	REFERENCES [CrimeType].[DimCrimeType] ([CrimeTypeID])


