-- Q9
-- Your query goes here.
WITH RouteCounts AS (
    SELECT station_id, COUNT(route_id) AS num_routes
    FROM station_orders
    GROUP BY station_id
),
DetailedRoutes AS (
    SELECT stations.station_name, station_orders.route_id, routes.line_id, RouteCounts.num_routes
    FROM station_orders
    JOIN stations ON station_orders.station_id = stations.station_id
    JOIN routes ON station_orders.route_id = routes.route_id
    JOIN RouteCounts ON station_orders.station_id = RouteCounts.station_id
)
SELECT station_name, route_id, line_id, num_routes
FROM DetailedRoutes
ORDER BY line_id ASC, route_id ASC;
