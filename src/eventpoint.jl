"""

# Example



```jldoctest
using EventSpaceAlgebra, CWBProjectSummaryDatasets, DataFrames, Dates

catalog = CWBProjectSummaryDatasets.dataset("EventMag4", "Catalog")

function EventSpaceAlgebra.EventPoint(time, lat, lon, mag, depth)
    EventPoint(
        EventTimeJD(time),
        Latitude(lat * u"°"),
        Longitude(lon * u"°"),
        EventMagnitude{RichterMagnitude}(mag),
        Depth(depth * u"km")
    )
end

transform!(catalog, :time => (ByRow(t -> DateTime(t, "yyyy/mm/dd HH:MM"))); renamecols = false)
transform!(catalog, [:time, :Lat, :Lon, :Mag, :Depth] => ByRow(EventPoint) => :EventPoint)

nothing

# output

```

"""
struct EventPoint{T1,T2,T3,U1,U3,M}
    time::TemporalCoordinate{T1,U1}
    lat::Latitude{T2}
    lon::Longitude{T2}
    mag::EventMagnitude{M}
    depth::Depth{T3,U3}
end


# CHECKPOINT: from "Implement Distance Calculations Between Coordinates"
# - `haversine_distance` between two `EventPoint`.
# - Seemingly that there is already a function `Distances.haversine`: https://discourse.julialang.org/t/geodesy-how-to-calculate-the-straight-line-distance-between-two-locations-which-is-represented-by-longitude-and-latitude/19984/6?u=okatsn
# - Besides `haversine_distance`, you also needs to build `geodesic_distance_with_depth`.
