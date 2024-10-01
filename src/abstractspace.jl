# """
# Abstract type `AbstractCoordinate` are the supertype for all dimension/coordinate specification, such as `Longitude`, `Latitude` and `EventTime`.
# """
# abstract type AbstractCoordinate{D,U} end

"""
`EventTime{T,U}` with a `value` of `Quantity{T,Unitful.𝐓,U}`.

It allows any kind of unit dimension time (`𝐓`).

It is recommended to always use `EventTimeXXX` (e.g., `EventTimeJD`, `EventTimeMS`) instead when possible.

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
EventTime(5.0, jd) == EventTime(5.0u"jd") == EventTime(Quantity(5.0u"jd")) == EventTimeJD(5.0)

# output

true
```
"""
EventTime(n, ::typeof(jd)) = EventTimeJD(n)


# Explicitly define EventTimeMS
# # The purpose of defining the const EventTimeMS is for a specific concrete type mapping (i.e., Integer with the unit of ms_epoch).
"""
`EventTimeMS` is the type of `EventTime{Int,typeof(ms_epoch)}`.

See https://docs.julialang.org/en/v1/manual/types/#UnionAll-Types
and https://docs.julialang.org/en/v1/manual/types/#Type-Aliases

"""
const EventTimeMS = EventTime{Int,typeof(ms_epoch)}

"""
`EventTimeMS(n::Int)`.

# Example

```jldoctest testmsep
using EventSpaceAlgebra, Unitful
EventTime(5, ms_epoch) == EventTimeMS(5) == EventTimeMS(5u"ms_epoch") == EventTimeMS(5.0u"ms_epoch")

# output

true
```

Noted that `EventTimeMS(5.0u"ms_epoch")` works due to `Unitful`'s conversion that will try to convert `Float64` to `Int`.

Noted that `EventTimeMS(n)` for `n` other than `Int` it will be dispatched to the inner constructor, i.e., `EventTime{...}(n)`, and may throw error:

```jldoctest testmsep
julia> EventTimeMS(5u"ms_epoch") # Dispatched to `EventTime` method (legal input)
EventTimeMS(5 ms_epoch)

julia> EventTimeMS(5.0u"ms_epoch") # Dispatched to `EventTime` method (legal input)
EventTimeMS(5 ms_epoch)

julia> EventTimeMS(5) # Dispatched to `EventTimeMS` method. (expected usage)
EventTimeMS(5 ms_epoch)

julia> EventTimeMS(5.0) # Dispatched to `EventTime` method (illegal input)
ERROR: DimensionError: ms_epoch and 5.0 are not dimensionally compatible.
[...]
```

"""
EventTimeMS(n::Int) = EventTimeMS(Quantity(n, ms_epoch)) # `::Int` is critical otherwise it falls back to `EventTime{Int,typeof(ms_epoch)}(value)`



# Explicitly define EventTimeJD
"""
`EventTimeJD` is the type of `EventTime{Float64,typeof(jd)}`.
"""
const EventTimeJD = EventTime{Float64,typeof(jd)}

"""
`EventTimeJD(n::Float64)`.

# Example

```jldoctest
using EventSpaceAlgebra
EventTime(5.1, jd) == EventTimeJD(5.1)

# output

true
```

```jldoctest
using EventSpaceAlgebra
typeof(EventTime(0.1, jd)) == typeof(EventTimeJD(5.1))

# output

true
```

Noted that the `EventTime` with integer Julian Day (`jd`) can be accepted, but not `EventTimeJD` and won't be dispatched to such as `to_datetime`.

```jldoctest testjd
julia> using EventSpaceAlgebra, Unitful
```

```jldoctest testjd
julia> a = EventTime(5.0, jd)
EventTimeJD(5.0 jd)

julia> b = EventTime(5u"jd")
EventTime{Int64, Unitful.FreeUnits{(jd,), 𝐓, nothing}}(5 jd)

julia> to_datetime(a)
-4713-11-29T12:00:00

julia> to_datetime(b)
ERROR: MethodError: no method matching to_datetime(::EventTime{Int64, Unitful.FreeUnits{(jd,), 𝐓, nothing}})
```
"""
EventTimeJD(n::Float64) = EventTimeJD(Quantity(n, jd))

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
