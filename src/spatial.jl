latlondocstring(; fnname="Latitude") = """
`Longitude` and `Latitude` by default defined in the unit of `°` (`\\degree`).

```
struct $fnname{T} <: AngleSpace
    value::EventAngleDegree{T}
    $fnname{T}(value::T) where {T<:Real} = new(value * u"°")
end
```

It is not mutable because when converting to it other units such as `m/m` or `rad`, it loses its nature and become a quantity of other meaning.

```jldoctest
julia> using Unitful, EventSpaceAlgebra

julia> typeof(1u"°") <: EventSpaceAlgebra.EventAngleDegree
true

julia> typeof(1u"rad") <: EventSpaceAlgebra.EventAngleDegree
false
```


# Example

```
$fnname(value) = $fnname(value * u"°")
```

```jldoctest
using Unitful, EventSpaceAlgebra
$fnname(90u"°").value == $fnname(0.5*π*u"rad").value

# output

true
```
"""


const EventAngleDegree{T} = Quantity{T,Unitful.NoDims,typeof(u"°")} where {T}
abstract type AngleSpace end


"""
$(latlondocstring())
"""
struct Latitude{T} <: AngleSpace
    value::EventAngleDegree{T}
    Latitude{T}(value::T) where {T<:Real} = new(value * u"°")
end

"""
$(latlondocstring(;fnname = "Longitude"))
"""
struct Longitude{T} <: AngleSpace
    value::EventAngleDegree{T}
    Longitude{T}(value::T) where {T<:Real} = new(value * u"°")
end

# CHECKPOINT: Spatial Units
# - Since Latitude and Longitude can only be degree or rad within a fixed range, only helper function for converting arbitrary degree (radian) to the ±90°/±180° (±0.5π/±π) is required, and it is no need to define specific units like `ms_epoch` and `jd`, such as `@unit lon "lon" Longitude 1u"°" false` or `@unit lat "lat" Latitude 1u"°" false`

# - Continue from "the unit type (e.g., degrees or radians)"


# Latitude and Longitude operations
function Base.:+(l::Longitude, delta::EventAngleDegree)
    Longitude(l.value + delta)
end

# function Base.:-(lat::Latitude{U}, delta::Quantity{<:Number,U}) where {U}
#     Latitude{U}(lat.value - delta)
# end

# # Longitude operations
# function Base.:+(lon::Longitude{U}, delta::Quantity{<:Number,U}) where {U}
#     Longitude{U}(lon.value + delta)
# end

# function Base.:-(lon::Longitude{U}, delta::Quantity{<:Number,U}) where {U}
#     Longitude{U}(lon.value - delta)
# end
