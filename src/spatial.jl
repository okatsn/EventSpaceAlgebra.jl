EventAngleDegree{T} = Quantity{T,Unitful.NoDims,typeof(u"°")} where {T<:Real}
EventAngleRadian{T} = Quantity{T,NoDims,typeof(u"rad")} where {T<:Real} # This is a shorthand for referring such type, and thus does not exported.

abstract type AngularCoordinate <: EventCoordinate end
abstract type DepthCoordinate <: EventCoordinate end


latlondocstring(; fnname="Latitude") = """
`Longitude` and `Latitude` by default defined in the unit of `°` (`\\degree`).

```
struct $fnname{T} <: AngularCoordinate
    value::EventAngleDegree{T}
    $fnname{T}(value::T) where {T<:Real} = new(value * u"°")
end
```

It is not mutable because when converting to it other units such as `m/m` or `rad`, it loses its nature and become a quantity of other meaning.

```jldoctest
julia> using EventSpaceAlgebra

julia> typeof(1u"°") <: EventSpaceAlgebra.EventAngleDegree
true

julia> typeof(1u"rad") <: EventSpaceAlgebra.EventAngleDegree
false
```
You can define `$fnname` with `u"rad"`, but it will be converted to the unit of degree.
It should be noted that input with any other dimensionless quantities is intended to trigger an error, for example such as `u"m/m"`, because we cannot guarantee whether a dimensionless unit like `u"m/m"` is derived to be the quantity of radian, or something else.

```jldoctest
julia> using EventSpaceAlgebra

julia> $fnname(0.5*π*u"rad").value.val # Radian will be converted to degree.
90.0

julia> $fnname(0.5*π*u"rad").value |> typeof
Unitful.Quantity{Float64, NoDims, $(typeof(u"°"))}

julia> 0.5*π*u"m/m" == 0.5*π*u"rad"
true

julia> Longitude(0.5*π*u"m/m")
ERROR: MethodError: no method matching Longitude(::Float64)

```


# Example

```
$fnname(value) = $fnname(value * u"°")
```

```jldoctest
using Unitful, EventSpaceAlgebra
$fnname(90.0u"°") == $fnname(0.5*π*u"rad")

# output

true
```



"""

"""
$(latlondocstring())
"""
struct Latitude{T} <: AngularCoordinate
    value::EventAngleDegree{T}
end

function Latitude(l::EventAngleRadian{T}) where {T<:Real}
    Latitude(uconvert(u"°", l))
end

"""
$(latlondocstring(;fnname = "Longitude"))
"""
struct Longitude{T} <: AngularCoordinate
    value::EventAngleDegree{T}
end

function Longitude(l::EventAngleRadian{T}) where {T<:Real}
    Longitude(uconvert(u"°", l))
end
# - Since Latitude and Longitude can only be degree or rad within a fixed range, only helper function for converting arbitrary degree (radian) to the ±90°/±180° (±0.5π/±π) is required, and it is no need to define specific units like `ms_epoch` and `jd`, such as `@unit lon "lon" Longitude 1u"°" false` or `@unit lat "lat" Latitude 1u"°" false`


"""
`latlon(lat, lon) = Latitude(lat * u"°"), Longitude(lon * u"°")`
"""
latlon(lat, lon) = Latitude(lat * u"°"), Longitude(lon * u"°")







struct Depth{T,U} <: DepthCoordinate
    value::Quantity{T,Unitful.𝐋,U}
end


"""
```jldoctest
julia> using EventSpaceAlgebra

julia> Depth(5)
Depth{Int64, Unitful.FreeUnits{(km,), 𝐋, nothing}}(5 km)

julia> Depth(5000u"m")
Depth{Int64, Unitful.FreeUnits{(m,), 𝐋, nothing}}(5000 m)
```
"""
Depth(n::Real) = Depth(n * u"km")
