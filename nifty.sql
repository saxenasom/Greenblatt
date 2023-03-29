SELECT 'NIFTY' as symbol,make_date(yr,mnth,1) as proxy,price,NULL
from
(
	SELECT 
		CAST(date_part('year',record_date) AS integer) AS yr,
		CAST(date_part('month',record_date) AS integer) AS mnth, 
		CAST(percentile_cont(0.5) WITHIN GROUP (ORDER BY day_close) AS numeric(8,2)) AS price
	FROM nse
	GROUP BY yr, mnth
)t1




CREATE TABLE nse(
                record_date date,
                day_open decimal(8,2),
                high decimal(8,2),
                low decimal(8,2),
                day_close decimal(8,2)
);

COPY nse 
from 'D:\Users\suman\Downloads\Code\Greenblatt\Raw\NIFTY 50_Data.csv'
with (format CSV,header)