-- Q10
-- Your query goes here.
WITH StationFlows AS (
    SELECT rail_ridership.station_id, lines.line_name, SUM(CAST(rail_ridership.average_flow AS REAL)) AS total_flow, SUM(rail_ridership.average_ons) AS total_ons, SUM(rail_ridership.average_offs) AS total_offs
    FROM rail_ridership
    JOIN lines ON rail_ridership.line_id = lines.line_id
    WHERE rail_ridership.season = 'Fall 2019'
    GROUP BY rail_ridership.station_id, lines.line_name
),
BypassedRatios AS (
    SELECT station_id, line_name, (total_flow - (total_ons + total_offs)) / total_flow AS bypassed_ratio
    FROM StationFlows
)
SELECT stations.station_name || '|' || BypassedRatios.line_name || '|' || ROUND(BypassedRatios.bypassed_ratio, 9) AS result
FROM BypassedRatios
JOIN stations ON BypassedRatios.station_id = stations.station_id
JOIN (
    SELECT line_name, MAX(bypassed_ratio) AS max_ratio
    FROM BypassedRatios
    GROUP BY line_name
) AS MaxRatios ON BypassedRatios.line_name = MaxRatios.line_name AND BypassedRatios.bypassed_ratio = MaxRatios.max_ratio
ORDER BY BypassedRatios.line_name ASC;
