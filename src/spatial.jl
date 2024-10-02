
mutable struct Latitude{T,U}
    value::Quantity{T,Unitful.NoDims,U}
end

mutable struct Longitude{T,U}
    value::Quantity{T,Unitful.NoDims,U}
end


# CHECKPOINT: Spatial Units
# - Since Latitude and Longitude can only be degree or rad within a fixed range, only helper function for converting arbitrary degree (radian) to the ±90°/±180° (±0.5π/±π) is required, and it is no need to define specific units like `ms_epoch` and `jd`, such as `@unit lon "lon" Longitude 1u"°" false` or `@unit lat "lat" Latitude 1u"°" false`
# - Continue from "the unit type (e.g., degrees or radians)"
