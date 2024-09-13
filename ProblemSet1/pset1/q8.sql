-- Q8
-- Your query goes here.
WITH AverageOns AS (
    SELECT AVG(rail_ridership.total_ons) AS avg_ons
    FROM rail_ridership
    JOIN lines ON rail_ridership.line_id = lines.line_id
    WHERE lines.line_name = 'Orange Line' AND rail_ridership.season = 'Fall 2018' AND rail_ridership.time_period_id = '01' AND rail_ridership.direction = 0
),
StationsAboveAverage AS (
    SELECT stations.station_name, rail_ridership.total_ons
    FROM rail_ridership
    JOIN stations ON rail_ridership.station_id = stations.station_id
    JOIN lines ON rail_ridership.line_id = lines.line_id
    JOIN AverageOns ON rail_ridership.total_ons > AverageOns.avg_ons
    WHERE lines.line_name = 'Orange Line' AND rail_ridership.season = 'Fall 2018' AND rail_ridership.time_period_id = '01' AND rail_ridership.direction = 0
)
SELECT station_name, total_ons
FROM StationsAboveAverage
ORDER BY total_ons DESC, station_name ASC;
