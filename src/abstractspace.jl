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
EventTime(5, ms_epoch) == EventTime(5u"ms_epoch") == EventTime(Quantity(5u"ms_epoch")) == EventTimeMS(5)

# output

true
```
"""
EventTime(n, ::typeof(ms_epoch)) = EventTimeMS(n)

"""
# Example

```jldoctest
using EventSpaceAlgebra, Unitful
EventTime(5, jd) == EventTime(5u"jd") == EventTime(Quantity(5u"jd")) == EventTimeJD(5)

# output

true
```
"""
EventTime(n, ::typeof(jd)) = EventTimeJD(n)


# Explicitly define EventTimeMS
const EventTimeMS = EventTime{Int,typeof(ms_epoch)}

"""
# Example

```jldoctest
using EventSpaceAlgebra
EventTime(5, ms_epoch) == EventTimeMS(5)

# output

true
```
"""
EventTimeMS(n) = EventTime(Quantity(n, ms_epoch))


# Explicitly define EventTimeJD
const EventTimeJD = EventTime{Float64,typeof(jd)}

"""
# Example

```jldoctest
using EventSpaceAlgebra
EventTime(5.1, jd) == EventTimeJD(5.1)

# output

true
```
"""
EventTimeJD(n) = EventTime(Quantity(n, jd))

# # Constructor from DateTime to EpochMillisecond
# function EventTime(dt::DateTime, ::Type{EpochMillisecond})
#     epoch = DateTime(1970, 1, 1) # FIXME: epoch should be verified. (epoch - datetime2epochms(epoch))
#     delta_ms = Millisecond(dt - epoch)
#     EventTime{EpochMillisecond}(delta_ms.value * u"EpochMillisecond")
# end


# # Constructor from DateTime to JulianDay
# function EventTime(dt::DateTime, ::Type{JulianDay})
#     jd_value = Dates.datetime2julian(dt)
#     EventTime{JulianDay}(jd_value * u"JulianDay")
# end

# TODO: Use Holy trait for dispatching "spatial" (e.g., Longitude) and "temporal" (e.g., eventTime) Coordinate.
