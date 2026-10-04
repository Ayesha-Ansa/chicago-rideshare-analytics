-- ============================================
-- Chicago Rideshare Operations Analysis
-- SQL Query Set
-- Data: City of Chicago Transportation Network Providers (TNP) trip data
-- Period: June - August 2026
-- ============================================


-- ============================================
-- 1. DEMAND PATTERNS
-- ============================================

-- Trips by hour of day
SELECT hour, COUNT(*) AS trip_count
FROM trips
GROUP BY hour
ORDER BY hour;

-- Trips by day of week
SELECT day_of_week, COUNT(*) AS trip_count
FROM trips
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-- Daily trip volume trend (for a line chart in the dashboard)
SELECT date, COUNT(*) AS trip_count
FROM trips
GROUP BY date
ORDER BY date;

-- Peak hour by day of week (cross-tab style)
SELECT day_of_week, hour, COUNT(*) AS trip_count
FROM trips
GROUP BY day_of_week, hour
ORDER BY day_of_week, hour;


-- ============================================
-- 2. FARE & REVENUE
-- ============================================

-- Average fare and trip total by hour (does pricing spike at peak times?)
SELECT hour, 
       AVG(fare) AS avg_fare, 
       AVG(trip_total) AS avg_trip_total,
       AVG(tip) AS avg_tip
FROM trips
GROUP BY hour
ORDER BY hour;

-- Total revenue by day of week
SELECT day_of_week, SUM(trip_total) AS total_revenue, COUNT(*) AS trip_count
FROM trips
GROUP BY day_of_week
ORDER BY total_revenue DESC;

-- Tip rate as % of fare, by hour (tipping behavior pattern)
SELECT hour, AVG(tip / NULLIF(fare, 0)) * 100 AS avg_tip_pct
FROM trips
WHERE fare > 0
GROUP BY hour
ORDER BY hour;


-- ============================================
-- 3. SHARED-RIDE ANALYSIS
-- ============================================

-- Overall share of trips that were shared vs solo
SELECT is_shared, COUNT(*) AS trip_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM trips), 2) AS pct_of_total
FROM trips
GROUP BY is_shared;

-- Shared-ride adoption by hour (when do people pool rides most?)
SELECT hour, 
       SUM(CASE WHEN is_shared = 'True' THEN 1 ELSE 0 END) AS shared_trips,
       COUNT(*) AS total_trips,
       ROUND(SUM(CASE WHEN is_shared = 'True' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS shared_pct
FROM trips
GROUP BY hour
ORDER BY hour;

-- Fare comparison: shared vs solo rides
SELECT is_shared, 
       AVG(fare) AS avg_fare, 
       AVG(trip_miles) AS avg_miles,
       AVG(trip_total) AS avg_trip_total
FROM trips
GROUP BY is_shared;

-- Average number of trips pooled, among shared rides only
SELECT AVG(trips_pooled) AS avg_pooled
FROM trips
WHERE is_shared = 'True' AND trips_pooled > 0;


-- ============================================
-- 4. ZONE (COMMUNITY AREA) ANALYSIS
-- ============================================

-- Top 10 pickup zones by trip volume
SELECT pickup_community_area, COUNT(*) AS trip_count
FROM trips
WHERE pickup_community_area != -1
GROUP BY pickup_community_area
ORDER BY trip_count DESC
LIMIT 10;

-- Zones with highest average fare (at least 500 trips, to avoid noise from tiny samples)
SELECT pickup_community_area, 
       AVG(fare) AS avg_fare, 
       COUNT(*) AS trip_count
FROM trips
WHERE pickup_community_area != -1
GROUP BY pickup_community_area
HAVING trip_count > 500
ORDER BY avg_fare DESC
LIMIT 10;

-- Net flow by zone: pickups minus dropoffs (positive = net demand source, negative = net destination)
-- Note: can be slow on large datasets due to the correlated subquery;
-- consider rewriting with a JOIN for production use
SELECT area, (pickups - dropoffs) AS net_flow FROM (
    SELECT pickup_community_area AS area, COUNT(*) AS pickups,
        (SELECT COUNT(*) FROM trips t2 WHERE t2.dropoff_community_area = t1.pickup_community_area) AS dropoffs
    FROM trips t1
    WHERE pickup_community_area != -1
    GROUP BY pickup_community_area
) sub
ORDER BY net_flow DESC
LIMIT 10;


-- ============================================
-- 5. TRIP EFFICIENCY
-- ============================================

-- Average speed by hour (traffic congestion proxy)
SELECT hour, AVG(avg_speed_mph) AS avg_speed
FROM trips
WHERE avg_speed_mph IS NOT NULL AND avg_speed_mph < 80  -- filter unrealistic outliers
GROUP BY hour
ORDER BY hour;

-- Average trip distance and duration by day of week
SELECT day_of_week, 
       AVG(trip_miles) AS avg_miles, 
       AVG(trip_seconds)/60 AS avg_minutes
FROM trips
GROUP BY day_of_week;
