
mutable struct Latitude{T,U}
    value::Quantity{T,Unitful.NoDims,U}
end

mutable struct Longitude{T,U}
    value::Quantity{T,Unitful.NoDims,U}
end

latlondocstring(; fnname="Latitude") = """
`Longitude` and `Latitude` by default defined in the unit of `°` (`\\degree`).

```
mutable struct $fnname{T,U}
    value::Quantity{T,Unitful.NoDims,U}
end
```

It is mutable, and feel free to convert the `Quantity` to other dimensionless angle units using `Unitful.uconvert`.

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

"""
$(latlondocstring())
"""
Latitude(value) = Latitude(value * u"°")

"""
$(latlondocstring(;fnname = "Longitude"))
"""
Longitude(value) = Longitude(value * u"°")

# CHECKPOINT: Spatial Units
# - Since Latitude and Longitude can only be degree or rad within a fixed range, only helper function for converting arbitrary degree (radian) to the ±90°/±180° (±0.5π/±π) is required, and it is no need to define specific units like `ms_epoch` and `jd`, such as `@unit lon "lon" Longitude 1u"°" false` or `@unit lat "lat" Latitude 1u"°" false`
# - The reason for Latitude or Longitude to be mutable is that it is safe to convert the Quantity inside through Unitful framework.
# - Continue from "the unit type (e.g., degrees or radians)"
