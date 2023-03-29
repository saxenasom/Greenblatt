CREATE TABLE pva_import(
                record_symbol varchar(15),
                series char(2),
                day_open decimal(8,2),
                high decimal(8,2),
                low decimal(8,2),
                day_close decimal(8,2),
                day_last decimal(8,2),
                prev_close decimal(8,2),
                tottrdqty bigint,
                tottrdval decimal(15,2),
                record_date date
);
COPY pva_import
FROM 'D:\Greenblatt\pva.csv'
WITH (FORMAT CSV, HEADER);


CREATE TABLE pva_temp AS
SELECT
	CASE WHEN (new_symbol IS NOT NULL AND record_date<change_date) THEN new_symbol
	ELSE record_symbol
	END AS symbol,
	record_date,
	CAST(tottrdval /tottrdqty AS numeric(8,2)) AS avgprice,
	tottrdval
FROM pva_import LEFT JOIN symbolchange
ON pva_import.record_symbol = symbolchange.old_symbol;

DROP TABLE pva_import;
ALTER TABLE pva_temp ADD CONSTRAINT pva_temp_primary_key PRIMARY KEY (symbol,record_date);


CREATE TABLE pva_daily AS
SELECT 
	pva_temp.symbol,
	record_date,
	CASE WHEN (multiplier IS NOT NULL) THEN CAST(avgprice/multiplier as numeric(8,2))
	ELSE avgprice
	END AS price_adj,
	tottrdval
FROM pva_temp left join splits
on 
pva_temp.symbol=splits.symbol
AND from_date <= record_date AND record_date < ex_date;

DROP TABLE pva_temp;
ALTER TABLE pva_daily ADD CONSTRAINT pva_daily_primary_key PRIMARY KEY (symbol,record_date);


CREATE TABLE pva AS
SELECT
	symbol, 
	CAST(date_part('year',record_date) AS integer) AS yr,
	CAST(date_part('month',record_date) AS integer) AS mnth, 
	CAST (percentile_cont(0.5) WITHIN GROUP (ORDER BY tottrdval) AS numeric(15,2)) AS turnover,
	CAST (percentile_cont(0.5) WITHIN GROUP (ORDER BY price_adj) AS numeric(8,2)) AS price
FROM pva_daily
GROUP BY symbol, yr, mnth;

ALTER TABLE pva ADD CONSTRAINT pva_primary_key PRIMARY KEY (symbol, yr, mnth);
DROP TABLE pva_daily;


CREATE TABLE reports as
SELECT eps.symbol,eps.report_date,interest,pbt,np,eps,assets
FROM eps JOIN assets
ON eps.symbol=assets.symbol
and eps.report_date=assets.report_date