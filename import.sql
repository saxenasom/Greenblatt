CREATE TABLE eps(
                symbol varchar(30),
                report_date date,
                interest decimal(10,2),
                pbt decimal(10,2),		--Profit Before Tax
                np decimal(10,2),		--Net Profit
                eps decimal(10,2)
);
COPY eps
FROM 'D:\Greenblatt\eps.csv'
WITH (FORMAT CSV,header);


CREATE TABLE assets(
                symbol varchar(30),
                report_date date,
                assets decimal(10,2)
);
COPY assets
FROM 'D:\Greenblatt\assets.csv'
WITH (FORMAT CSV,header);


CREATE TABLE reports(
                symbol varchar(30),
                report_month varchar(3),
                report_year varchar(4),
                report_date date
);
COPY reports
FROM 'D:\Greenblatt\reports.csv'
WITH (FORMAT CSV,header);


CREATE TABLE symbolchange(
                company varchar(70),
                old_symbol varchar(15),
                new_symbol varchar(15),
                change_date date
);
copy symbolchange
from 'D:\Greenblatt\symbolchange.csv'
WITH (FORMAT CSV);


CREATE TABLE splits(
	symbol varchar(15),
	series char(2),
	face_value numeric(5,2),
	purpose text,
	from_date date,
	ex_date date,
	multiplier numeric(8,5)
);
copy splits
from 'D:\Greenblatt\splits.csv'
WITH (FORMAT CSV,header);


CREATE TABLE reports as
SELECT eps.symbol,eps.report_date,interest,pbt,np,eps,assets
FROM eps JOIN assets
ON eps.symbol=assets.symbol
and eps.report_date=assets.report_date