-- Q1
-- Your query goes here.
SELECT station_id, route_id, distance_from_last_station_miles AS result
FROM station_orders
WHERE distance_from_last_station_miles >= 1
ORDER BY distance_from_last_station_miles DESC, route_id ASC, station_id ASC;
