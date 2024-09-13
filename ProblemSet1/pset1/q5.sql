-- Q5
-- Your query goes here.
SELECT stations.station_name, rail_ridership.season, ROUND(AVG(rail_ridership.number_service_days), 0)
FROM rail_ridership
JOIN stations ON rail_ridership.station_id = stations.station_id
GROUP BY stations.station_name, rail_ridership.season
ORDER BY AVG(rail_ridership.number_service_days) DESC, rail_ridership.season ASC, stations.station_name ASC;
