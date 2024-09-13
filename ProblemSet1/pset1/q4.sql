-- Q4
-- Your query goes here.
SELECT routes.route_id, routes.direction, routes.route_name, COUNT(station_orders.station_id), SUM(station_orders.distance_from_last_station_miles)
FROM routes
JOIN station_orders ON routes.route_id = station_orders.route_id
JOIN lines ON routes.line_id = lines.line_id
WHERE lines.line_name != 'Green Line'
GROUP BY routes.route_id, routes.direction, routes.route_name
HAVING SUM(station_orders.distance_from_last_station_miles) IS NOT NULL
ORDER BY COUNT(station_orders.station_id) DESC, SUM(station_orders.distance_from_last_station_miles) DESC;
