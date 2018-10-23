USE crimeproject;

-- Taking averages of previous and next year when budget / staff nos data is misisng
-- Cleaning Budgets and StaffNos

;WITH CTE AS(
SELECT 
	 *
	,cast(left([FY], 4) + '-01-01' as date) as [Year]
FROM [trash].[BudgetAndStaffNos]
)
SELECT 
	 *
	,CASE
	 WHEN [Borough] = 'Brent' AND FY = '2011/12' THEN [FYstaffnos] * 46622.7  -- (46622.7 is the most recent Budget to NoStaff ratio)
	 WHEN [Borough] = 'Bromley' AND FY = '2017/18' THEN [FYstaffnos] * 44052.17  -- (44052.17 is the most recent Budget to NoStaff ratio)
	 WHEN [Borough] = 'Croydon' AND FY = '2011/12' THEN [FYstaffnos] * 36926.87  -- (36926.87 is the most recent Budget to NoStaff ratio)
	 WHEN [Borough] = 'Croydon' AND FY = '2012/13' THEN [FYstaffnos] * 36926.87
	 WHEN [Borough] = 'Islington' AND FY = '2011/12' THEN [FYstaffnos] * 474305.4  -- (474305.4 is the most recent Budget to NoStaff ratio)
	 WHEN [Borough] = 'Harrow' AND [FY] = '2017/18' THEN 0 -- (No data available)
	 WHEN [Borough] = 'Hounslow' AND [FY] = '2015/16' THEN 0
	 ELSE [FYbudget]
	END AS FYBUDGETS
	,CASE
	 WHEN [Borough] = 'Hillingdon' AND FY = '2011/12' THEN [FYbudget] / 41847.13  -- (41847.13 is the most recent Budget to NoStaff ratio)
	 WHEN [Borough] = 'Hillingdon' AND FY = '2012/13' THEN [FYbudget] / 41847.13
	 WHEN [Borough] = 'Hillingdon' AND FY = '2013/14' THEN [FYbudget] / 41847.13
	 WHEN [Borough] = 'Hillingdon' AND FY = '2014/15' THEN [FYbudget] / 41847.13
	 WHEN [Borough] = 'Hillingdon' AND FY = '2015/16' THEN [FYbudget] / 41847.13
	 WHEN [Borough] = 'Lambeth' AND FY = '2013/14' THEN [FYbudget] / 900000		  -- (900000 is the most recent Budget to NoStaff ratio)
	 WHEN [Borough] = 'Waltham Forest' AND FY = '2011/12' THEN [FYbudget] / 98375 -- (98375 is the most recent Budget to NoStaff ratio)
	 WHEN [Borough] = 'Waltham Forest' AND FY = '2012/13' THEN [FYbudget] / 98375 
	 WHEN [Borough] = 'Waltham Forest' AND FY = '2013/14' THEN [FYbudget] / 98375 
	 WHEN [Borough] = 'Waltham Forest' AND FY = '2014/15' THEN [FYbudget] / 98375 
	 WHEN [Borough] = 'Waltham Forest' AND FY = '2015/16' THEN [FYbudget] / 98375
	 WHEN [Borough] = 'Harrow' AND FY = '2011/12' THEN 0 -- (No data available)
	 WHEN [Borough] = 'Harrow' AND FY = '2012/13' THEN 0
	 WHEN [Borough] = 'Harrow' AND FY = '2013/14' THEN 0
	 WHEN [Borough] = 'Harrow' AND FY = '2014/15' THEN 0
	 WHEN [Borough] = 'Harrow' AND FY = '2015/16' THEN 0
	 WHEN [Borough] = 'Harrow' AND FY = '2016/17' THEN 0
	 ELSE [FYstaffnos]
	END AS FYStaffNUM
--INTO clean.BudgetandStaffNums
FROM CTE

-- Change Financial year to calandar year for better comparisons
SELECT 
	  [Borough]
	 ,[Year]
	 ,CASE 
		WHEN [FYBUDGETS] = 0 THEN CAST(ROUND(0,2) as dec(10,2))
		WHEN LAG([Year]) OVER (PARTITION BY [Borough] ORDER BY [Year]) IS NULL THEN CAST(ROUND([FYBUDGETS],2) as dec(10,2))
		ELSE CAST(ROUND(0.25 * LAG([FYBUDGETS]) OVER (PARTITION BY [Borough] ORDER BY [Year]) + 0.75 * [FYBUDGETS], 2) as dec(10,2))
	  END as CYbudget
	 ,CASE 
		WHEN [FYStaffNUM] = 0 THEN CAST(ROUND(0 , 2) as dec(5, 2))
		WHEN LAG([Year]) OVER (PARTITION BY [Borough] ORDER BY [Year]) IS NULL THEN CAST(ROUND([FYStaffNUM] ,2) as dec(5, 2))
		ELSE CAST(ROUND(0.25 * LAG([FYStaffNUM]) OVER (PARTITION BY [Borough] ORDER BY [Year]) + 0.75 * [FYStaffNUM] , 2) as dec(5, 2))
	  END as CYstaffnos
--INTO [clean].[BudgetandStaffNos]
FROM [clean].[BudgetandStaffNums]


---------------------------------------------------------------------------------------------------------------------------------------------
-- Splitting merged boroughs by adding new rows for Kensington & Chelsea, Hammersmith and Fulham sepeartely (worked out numbers in Excel)
---------------------------------------------------------------------------------------------------------------------------------------------
--INSERT INTO [clean].[BudgetAndStaffNos] ([Borough], [FY], [FYbudget], [FYstaffnos])
--VALUES
-- ('Kensington & Chelsea', '2011/12'	,1176005 , 14.7607227279137)
--,('Kensington & Chelsea', '2012/13'	,1499253 , 18.8179963792609)
--,('Kensington & Chelsea', '2013/14'	,2310153 , 28.996073904497 )
--,('Kensington & Chelsea', '2014/15'	,1699653 , 21.3333333333333) 
--,('Kensington & Chelsea', '2015/16'	,1610653 , 13.6666666666667) 
--,('Kensington & Chelsea', '2016/17'	,1470653 , 10.6666666666667) 
--,('Kensington & Chelsea', '2017/18'	,1737054 , 12.5988768254646) 
--,('Hammersmith & Fulham', '2011/12'	,1176005 , 14.7607227279137) 
--,('Hammersmith & Fulham', '2012/13'	,1499253 , 18.8179963792609) 
--,('Hammersmith & Fulham', '2013/14'	,2310153 , 28.996073904497 )
--,('Hammersmith & Fulham', '2014/15'	,1699653 , 21.3333333333333) 
--,('Hammersmith & Fulham', '2015/16'	,1610653 , 13.6666666666667) 
--,('Hammersmith & Fulham', '2016/17'	,1470653 , 10.6666666666667) 
--,('Hammersmith & Fulham', '2017/18'	,1737054 , 12.5988768254646) 
--,('Westminster',	'2011/12'		,1494990 , 27.5965091105431) 
--,('Westminster', '2012/13'			,1273494 , 23.5078420412324) 
--,('Westminster', '2013/14'			,1160694 , 21.4256299677942) 
--,('Westminster', '2014/15'			,1155694 , 21.3333333333333) 
--,('Westminster', '2015/16'			,1030694 , 13.6666666666667) 
--,('Westminster', '2016/17'			,798694 ,  10.6666666666667) 
--,('Westminster', '2017/18'			,162900 ,  2.17555158796736)
--,('Kingston upon Thames', '2011/12'	,738590.476190476,16	   )
--,('Kingston upon Thames', '2012/13'	,738590.476190476,16 	   )
--,('Kingston upon Thames', '2013/14'	,738590.476190476,16 	   )
--,('Kingston upon Thames', '2014/15'	, 969400,21				   )
--,('Kingston upon Thames', '2015/16'	,923450,18.5 			   )
--,('Kingston upon Thames', '2016/17'	,873050,17 				   )
--,('Kingston upon Thames', '2017/18'	,732100,14 				   )
--,('Richmond upon Thames', '2011/12'	,738590.476190476,16	   )
--,('Richmond upon Thames', '2012/13'	,738590.476190476,16	   )
--,('Richmond upon Thames', '2013/14'	,738590.476190476,16	   )
--,('Richmond upon Thames', '2014/15'	,969400,21				   )
--,('Richmond upon Thames', '2015/16'	,923450,18.5			   )
--,('Richmond upon Thames', '2016/17'	,873050,17				   )
--,('Richmond upon Thames', '2017/18'	,732100,14				   )

--DELETE FROM [clean].[BudgetAndStaffNos]
--WHERE [Borough] = 'Westminster' OR [Borough] = 'Kensington & Chelsea, Hammersmith & Fulham, and Westminster' OR [Borough] = 'Kingston & Richmond'

--DELETE FROM [clean].[BudgetAndStaffNos]
--WHERE [FY] = '2018/19'