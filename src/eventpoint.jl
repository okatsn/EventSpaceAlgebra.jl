
struct EventPoint
    time::EventTime
    lat::Latitude
    lon::Longitude
    mag::EventMagnitude
    depth::Depth
end


# CHECKPOINT: from "Implement Distance Calculations Between Coordinates"
# - `haversine_distance` between two `EventPoint`.
# - Seemingly that there is already a function `Distances.haversine`: https://discourse.julialang.org/t/geodesy-how-to-calculate-the-straight-line-distance-between-two-locations-which-is-represented-by-longitude-and-latitude/19984/6?u=okatsn
# - Besides `haversine_distance`, you also needs to build `geodesic_distance_with_depth`.
