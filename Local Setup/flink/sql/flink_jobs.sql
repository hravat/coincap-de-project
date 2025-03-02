insert
	into
	rates_api_raw_postgres_sink (id,
	symbol,
	rateUsd,
	type,
	source,
	event_timestamp)
select
	id,
	symbol,
	rateUsd,
	type, 
	source,
	event_timestamp
from
	rates_api_raw;