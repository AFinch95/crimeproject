use crimeproject;
go

-- create schema for raw data
create schema [raw]
;

create schema [clean];

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

-- create schema for trash
create schema [trash]
;

--transfer all trash
alter schema [trash] transfer [dbo].[LondonLSOAcodes]
;

alter schema [trash] transfer [raw].[crimedataraw]
;

