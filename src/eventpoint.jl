abstract type AbstractLLPoint end
abstract type AbstractCartesianPoint end

UnitfulQuantityLength{T} = Unitful.Quantity{T,Unitful.𝐋,<:Unitful.FreeUnits}
UnitfulQuantityTime{T} = Unitful.Quantity{T,Unitful.𝐓,<:Unitful.FreeUnits}

# KEYNOTE: Define XYZT as parametric type results in auto conversion
# - If XYZT is defined as parametric type of Unit, e.g., `XYZ{T,U}` with `x::Quantity{T,Unitful.𝐋,U} ...`,
#   `uconvert!` basically pours water into sand. For example, for `pt::XYZT{U}` where `U` is the unit of meter,
#   `x_in_km = uconvert(u"km", pt.x)` is a `Quantity` of unit in kilometer; however, in the step `pt.x = x_in_km` the unit is converted back `u"m"`
#   since `XYZT` is fixed to have the parametric type `U`.
mutable struct XYZT{T1,T2} <: AbstractCartesianPoint
    x::UnitfulQuantityLength{T1}
    y::UnitfulQuantityLength{T1}
    z::UnitfulQuantityLength{T1}
    t::UnitfulQuantityTime{T2}
    ref::AbstractLLPoint
end

mutable struct XYZ{T1} <: AbstractCartesianPoint
    x::UnitfulQuantityLength{T1}
    y::UnitfulQuantityLength{T1}
    z::UnitfulQuantityLength{T1}
    ref::AbstractLLPoint
end


get_value(xyzt::AbstractCartesianPoint, symb::Symbol) = getproperty(xyzt, symb).val
get_unit(xyzt::AbstractCartesianPoint, symb::Symbol) = unit(getproperty(xyzt, symb))

get_values(xyzt::AbstractCartesianPoint, symbs::Vector{Symbol}) = get_value.(Ref(xyzt), symbs)

get_units(xyzt::AbstractCartesianPoint, symbs::Vector{Symbol}) = get_unit.(Ref(xyzt), symbs)


get_values(p::XYZ) = get_values(p, [:x, :y, :z])
get_values(p::XYZT) = get_values(p, [:x, :y, :z, :t])

get_units(p::XYZ) = get_units(p, [:x, :y, :z])
get_units(p::XYZT) = get_units(p, [:x, :y, :z, :t])


"""

# Example



```jldoctest a7468
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

```jldoctest a7468
evpt = EventPoint(
    5, # jd
    21, # °N
    -3, # °E
    -3.2 , # RichterMagnitude
    1 # km depth
)

evpt.size

# output

EventMagnitude{RichterMagnitude}(-3.2)
```



"""
struct EventPoint{T1,T2,T3,U1,U3,M} <: AbstractLLPoint
    time::TemporalCoordinate{T1,U1}
    lat::Latitude{T2}
    lon::Longitude{T2}
    size::EventMagnitude{M}
    depth::Depth{T3,U3}
end


mutable struct ArbitraryPoint <: AbstractLLPoint
    time::Union{TemporalCoordinate,Nothing}
    lat::Union{Latitude,Nothing}
    lon::Union{Longitude,Nothing}
    size::Union{EventPointSize,Nothing}
    depth::Union{Depth,Nothing}
end

ArbitraryPoint(time::TemporalCoordinate, lat::Latitude, lon::Longitude) = ArbitraryPoint(time, lat, lon, nothing, nothing)
ArbitraryPoint(lat::Latitude, lon::Longitude) = ArbitraryPoint(nothing, lat, lon, nothing, nothing)
ArbitraryPoint(lat::Latitude, lon::Longitude, depth::Depth) = ArbitraryPoint(nothing, lat, lon, nothing, depth)
ArbitraryPoint(time::TemporalCoordinate, lat::Latitude, lon::Longitude, depth::Depth) = ArbitraryPoint(time, lat, lon, nothing, depth)

# Interface


function shift!(apt::ArbitraryPoint, b::Quantity{T,D,typeof(deg_N)}) where {T,D}
    apt.lat = Latitude(apt.lat + (b.val * u"°")) # because 1u"°" + 1.2u"deg_N" returns Float64
    nothing
end

function shift!(apt::ArbitraryPoint, b::Quantity{T,D,typeof(deg_E)}) where {T,D}
    apt.lon = Longitude(apt.lon + (b.val * u"°"))
    nothing
end

function shift!(apt::ArbitraryPoint, b::Quantity{T,D,typeof(dep_km)}) where {T,D}
    apt.depth = Depth(apt.depth + uconvert(u"km", b))
    nothing
end

function shift!(apt::ArbitraryPoint, bs::Vararg{PointShiftingUnitQuantity})
    for b in bs
        shift!(apt, b)
    end
    nothing
end
# +/- operations between the component in the following list is intended to be incompatible, because I want these operations to be carried out under the `shift!` interface instead (for easier code maintaining and to avoid confusion).
for op in (:+, :-), AC in (:Latitude, :Longitude, :Depth)
    @eval function Base.$op(::$AC, ::PointShiftingUnitQuantity)
        throw(UnitIncompatible())
    end
end


# CHECKPOINT: from "Implement Distance Calculations Between Coordinates"
# - `haversine_distance` between two `EventPoint`.
# - Seemingly that there is already a function `Distances.haversine`: https://discourse.julialang.org/t/geodesy-how-to-calculate-the-straight-line-distance-between-two-locations-which-is-represented-by-longitude-and-latitude/19984/6?u=okatsn
# - Besides `haversine_distance`, you also needs to build `geodesic_distance_with_depth`.


function centerpoint(ps::Vector{<:XYZ})
    XYZ(
        mean(getproperty.(ps, :x)),
        mean(getproperty.(ps, :y)),
        mean(getproperty.(ps, :z)),
        only(unique(getproperty.(ps, :ref)))
    )
end

function centerpoint(ps::Vector{<:XYZT})
    XYZT(
        mean(getproperty.(ps, :x)),
        mean(getproperty.(ps, :y)),
        mean(getproperty.(ps, :z)),
        mean(getproperty.(ps, :t)),
        only(unique(getproperty.(ps, :ref)))
    )
end
