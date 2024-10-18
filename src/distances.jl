const EARTH_RADIUS = 6371_000u"m"  # Mean Earth radius in meters

function Distances.haversine(t1::T, t2::T, radius::Number=EARTH_RADIUS.val) where {T<:Tuple{Longitude,Latitude}}
    haversine(
        getproperty.(t1, :value), # Longitude
        getproperty.(t2, :value), # Latitude; # Please refer the source code haversine.jl of package `Distances.jl`.
        radius
    )
end

function Distances.haversine(t1::T, t2::T, radius::Number=EARTH_RADIUS.val) where {T<:Tuple{Latitude,Longitude}}
    (lat1, lon1) = t1
    (lat2, lon2) = t2
    haversine(
        (lon1, lat1),
        (lon2, lat2),
        radius
    )
end

"""
`Distances.haversine(p1::AbstractLLPoint, p2::AbstractLLPoint, radius::Number=EARTH_RADIUS.val)`
calculates Haversine distance ignoring depth.
"""
function Distances.haversine(p1::AbstractLLPoint, p2::AbstractLLPoint, radius::Number=EARTH_RADIUS.val)
    haversine(
        (p1.lat, p1.lon),
        (p2.lat, p2.lon),
        radius
    )
end

"""
Returns with `Unitful.unit`.
"""
function haversine_distance(lat1::Latitude{U}, lon1::Longitude{U},
    lat2::Latitude{U}, lon2::Longitude{U}) where {U}

    # Convert coordinates to radians
    φ1 = uconvert(u"rad", lat1.value)
    φ2 = uconvert(u"rad", lat2.value)
    Δφ = φ2 - φ1

    λ1 = uconvert(u"rad", lon1.value)
    λ2 = uconvert(u"rad", lon2.value)
    Δλ = λ2 - λ1

    # Haversine formula
    a = sin(Δφ / 2)^2 + cos(φ1) * cos(φ2) * sin(Δλ / 2)^2
    c = 2 * atan(sqrt(a), sqrt(1 - a))
    distance = EARTH_RADIUS * c

    return distance
end


haversine_distance(t1::T, t2::T) where {T<:Tuple{<:Latitude,<:Longitude}} = haversine_distance(t1..., t2...)
haversine_distance(t1::T, t2::T) where {T<:Tuple{<:Longitude,<:Latitude}} = haversine_distance(reverse(t1)..., reverse(t2)...)

const LLAUnit = (lat=u"°", lon=u"°", alt=u"m")

function Geodesy.LLA(lat::Latitude, lon::Longitude, dep::Depth)
    LLA(
        lat.value.val,
        lon.value.val,
        -uconvert(LLAUnit.alt, dep.value).val
    )
end

Geodesy.ECEF(args::EventCoordinate...; datum=wgs84) = ECEF(LLA(args...), datum)

Geodesy.LLA(evt::AbstractLLPoint) = LLA(evt.lat, evt.lon, evt.depth)
Geodesy.ECEF(evt::AbstractLLPoint; kwargs...) = ECEF(evt.lat, evt.lon, evt.depth; kwargs...)

Geodesy.ENU(evt::AbstractLLPoint, ref::AbstractLLPoint; datum=wgs84) = ENU(LLA(evt), LLA(ref), datum)

function ENUPoint(evt::AbstractLLPoint, ref::AbstractLLPoint; kwargs...)
    ENUPoint((ENU(evt, ref) .* LLAUnit.alt)...)
end

# # Optional
# Geodesy.LLA(lon::Longitude, lat::Latitude, dep::Depth) = LLA(lat, lon, dep)
# @test LLA(Longitude(153.023628u"°"), Depth(1.0u"km")) == LLA(-27.468937, 153.023628, -1000.0) # commutative property
