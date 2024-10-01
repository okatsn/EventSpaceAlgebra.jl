# """
# Abstract type `AbstractCoordinate` are the supertype for all dimension/coordinate specification, such as `Longitude`, `Latitude` and `EventTime`.
# """
# abstract type AbstractCoordinate{D,U} end

"""
`EventTime{T,U}` with `value` `Quantity{T,Unitful.𝐓,U}`.

It allows any kind of unit dimension time (`𝐓`); however,

# Example

```jldoctest

using EventSpaceAlgebra, Unitful
EventTime(5u"ms_epoch")

true

# output

true
```
"""
struct EventTime{T,U}
    value::Quantity{T,Unitful.𝐓,U}
end

# Other EventTime constructors that does not rely on Unitful.
"""
# Example

```jldoctest
using EventSpaceAlgebra, Unitful
EventTime(5, ms_epoch) == EventTime(5u"ms_epoch") == EventTime(Quantity(5u"ms_epoch"))

# output

true
```
"""
EventTime(n::Int, u::typeof(ms_epoch)) = EventTime(Quantity(n, u))

"""
# Example

```jldoctest
using EventSpaceAlgebra, Unitful
EventTime(5, jd) == EventTime(5u"jd") == EventTime(Quantity(5u"jd"))

# output

true
```
"""
EventTime(n::Int, u::typeof(jd)) = EventTime(Quantity(n, u))


# # Constructor from DateTime to EpochMillisecond
# function EventTime(dt::DateTime, ::Type{EpochMillisecond})
#     epoch = DateTime(1970, 1, 1) # FIXME: epoch should be verified. (epoch - datetime2epochms(epoch))
#     delta_ms = Millisecond(dt - epoch)
#     EventTime{EpochMillisecond}(delta_ms.value * u"EpochMillisecond")
# end

# # Optional
# const EventTimeMS = EventTime{EpochMillisecond}


# # Constructor from DateTime to JulianDay
# function EventTime(dt::DateTime, ::Type{JulianDay})
#     jd_value = Dates.datetime2julian(dt)
#     EventTime{JulianDay}(jd_value * u"JulianDay")
# end

# TODO: Use Holy trait for dispatching "spatial" (e.g., Longitude) and "temporal" (e.g., eventTime) Coordinate.
