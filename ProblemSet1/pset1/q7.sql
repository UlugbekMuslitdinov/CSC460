-- Q7
-- Your query goes here.
WITH TotalOffsPerStation AS (
    SELECT rail_ridership.station_id, rail_ridership.time_period_id, rail_ridership.season, SUM(rail_ridership.total_offs) AS total_offs
    FROM rail_ridership
    GROUP BY rail_ridership.station_id, rail_ridership.time_period_id, rail_ridership.season
),
MaxOffs AS (
    SELECT MAX(total_offs) AS max_offs
    FROM TotalOffsPerStation
)
SELECT time_periods.day_type, time_periods.period_start_time, TotalOffsPerStation.season, routes.line_id, stations.station_name, TotalOffsPerStation.total_offs
FROM TotalOffsPerStation
JOIN time_periods ON TotalOffsPerStation.time_period_id = time_periods.time_period_id
JOIN rail_ridership ON TotalOffsPerStation.station_id = rail_ridership.station_id AND TotalOffsPerStation.time_period_id = rail_ridership.time_period_id AND TotalOffsPerStation.season = rail_ridership.season
JOIN stations ON rail_ridership.station_id = stations.station_id
JOIN routes ON rail_ridership.line_id = routes.line_id
JOIN MaxOffs ON TotalOffsPerStation.total_offs = MaxOffs.max_offs;

