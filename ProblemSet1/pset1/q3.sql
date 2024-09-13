-- Q3
-- Your query goes here.
-- SELECT rail_ridership.season, lines.line_id, rail_ridership.direction, SUM(rail_ridership.total_ons) FROM rail_ridership 
-- JOIN time_periods ON rail_ridership.time_period_id = time_periods.time_period_id 
-- JOIN lines ON lines.line_id = rail_ridership.line_id 
-- JOIN routes ON routes.line_id = lines.line_id
-- JOIN station_orders ON station_orders.route_id = routes.route_id
-- JOIN stations ON stations.station_id = station_orders.station_id
-- WHERE time_periods.day_type = 'weekday' 
-- AND (time_periods.time_period_id = 'time_period_06' OR time_periods.time_period_id = 'time_period_07') 
-- AND lines.line_name = 'Red Line'
-- AND stations.station_name = 'Kendall/MIT'
-- GROUP BY rail_ridership.season
-- ORDER BY rail_ridership.season ASC, rail_ridership.direction ASC;

SELECT rail_ridership.season, rail_ridership.line_id, rail_ridership.direction, SUM(rail_ridership.total_ons)
FROM rail_ridership
JOIN stations ON rail_ridership.station_id = stations.station_id
JOIN lines ON rail_ridership.line_id = lines.line_id
JOIN time_periods ON rail_ridership.time_period_id = time_periods.time_period_id
WHERE stations.station_name = 'Kendall/MIT' AND lines.line_name = 'Red Line' 
AND time_periods.day_type = 'weekday' 
AND ((time_periods.period_start_time >= '16:00:00' 
AND time_periods.period_end_time <= '18:30:00') 
OR time_periods.time_period_id = 'time_period_07')
GROUP BY rail_ridership.season, rail_ridership.line_id, rail_ridership.direction
ORDER BY rail_ridership.season ASC, rail_ridership.direction ASC;
