-- Q2
-- Your query goes here.
SELECT lines.line_name, routes.direction_desc, first_station.station_name, last_station.station_name 
FROM routes 
JOIN lines ON routes.line_id = lines.line_id 
JOIN stations AS first_station ON routes.first_station_id = first_station.station_id 
JOIN stations AS last_station ON routes.last_station_id = last_station.station_id 
ORDER BY lines.line_name ASC, routes.direction_desc ASC, first_station.station_name ASC, last_station.station_name ASC;