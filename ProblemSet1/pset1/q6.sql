-- Q6
-- Your query goes here.
WITH SummerEntries AS (
    SELECT gated_station_entries.station_id, SUM(gated_station_entries.gated_entries) AS total_entries
    FROM gated_station_entries
    WHERE service_date BETWEEN '2021-06-01' AND '2021-08-31'
    GROUP BY gated_station_entries.station_id
),
MaxEntries AS (
    SELECT MAX(total_entries) AS max_entries
    FROM SummerEntries
)
SELECT stations.station_name, SummerEntries.total_entries
FROM SummerEntries
JOIN stations ON SummerEntries.station_id = stations.station_id
JOIN MaxEntries ON SummerEntries.total_entries = MaxEntries.max_entries;
