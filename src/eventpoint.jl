abstract type AbstractLLPoint end

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
struct EventPoint{T1,T2,T3,U1,U3,M} <: AbstractLLPoint
    time::TemporalCoordinate{T1,U1}
    lat::Latitude{T2}
    lon::Longitude{T2}
    mag::EventMagnitude{M}
    depth::Depth{T3,U3}
end


mutable struct ArbitraryPoint <: AbstractLLPoint
    time::Union{TemporalCoordinate,Nothing}
    lat::Union{Latitude,Nothing}
    lon::Union{Longitude,Nothing}
    mag::Union{EventMagnitude,Nothing}
    depth::Union{Depth,Nothing}
end

ArbitraryPoint(time::TemporalCoordinate, lat::Latitude, lon::Longitude) = ArbitraryPoint(time, lat, lon, nothing, nothing)
ArbitraryPoint(lat::Latitude, lon::Longitude) = ArbitraryPoint(nothing, lat, lon, nothing, nothing)
ArbitraryPoint(lat::Latitude, lon::Longitude, depth::Depth) = ArbitraryPoint(nothing, lat, lon, nothing, depth)
ArbitraryPoint(time::TemporalCoordinate, lat::Latitude, lon::Longitude, depth::Depth) = ArbitraryPoint(time, lat, lon, nothing, depth)

# Interface


function shift!(apt::ArbitraryPoint, b::Quantity{T,D,<:typeof(deg_N)}) where {T,D}
    apt.lat = apt.lat + uconvert(u"°", b) # because 1u"°" + 1.2u"deg_N" returns Float64
end

function shift!(apt::ArbitraryPoint, b::Quantity{T,D,<:typeof(deg_E)}) where {T,D}
    apt.lon = apt.lon + uconvert(u"°", b)
end

function shift!(apt::ArbitraryPoint, b::Quantity{T,D,<:typeof(dep_km)}) where {T,D}
    apt.depth = apt.depth + b
end

# +/- operations between the component in the following list is intended to be incompatible, because I want these operations to be carried out under the `shift!` interface instead (for easier code maintaining and to avoid confusion).
for op in (:+, :-), (C, U) in [(:Latitude, :deg_N), (:Longitude, :deg_E), (:Depth, :dep_km)]
    @eval function Base.$op(::$C, ::Quantity{T,D,<:typeof($U)}) where {T,D}
        throw(UnitIncompatible())
    end

    if op == :+
        @eval function Base.$op(b::Quantity{T,D,<:typeof($U)}, a::$C) where {T,D}
            $op(a, b)
        end
    end
end


# CHECKPOINT: from "Implement Distance Calculations Between Coordinates"
# - `haversine_distance` between two `EventPoint`.
# - Seemingly that there is already a function `Distances.haversine`: https://discourse.julialang.org/t/geodesy-how-to-calculate-the-straight-line-distance-between-two-locations-which-is-represented-by-longitude-and-latitude/19984/6?u=okatsn
# - Besides `haversine_distance`, you also needs to build `geodesic_distance_with_depth`.
