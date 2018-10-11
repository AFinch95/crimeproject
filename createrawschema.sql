use crimeproject;
go

-- create schema for raw data
create schema [raw]
;

--transfer all raw data to raw schema
alter schema [raw] transfer [dbo].[crimedataraw]
;

alter schema [raw] transfer [dbo].[noofstaffraw]
;

alter schema [raw] transfer [dbo].[noofyouthcentresraw]
;

alter schema [raw] transfer [dbo].[yclocationsraw]
;

alter schema [raw] transfer [dbo].[youthservicesbudgetsraw]
;