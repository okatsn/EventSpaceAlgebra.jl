abstract type EventCoordinate end
abstract type TemporalCoordinate{T,U} <: EventCoordinate end
# """
# Abstract type `AbstractCoordinate` are the supertype for all dimension/coordinate specification, such as `Longitude`, `Latitude` and `EventTime`.
# """
# abstract type AbstractCoordinate{D,U} end

"""
`EventTime{T,U}` with a `value` of `Quantity{T,Unitful.𝐓,U}`.

It allows any kind of unit dimension time (`𝐓`).

It is recommended to always use `EventTimeXXX` (e.g., `EventTimeJD`, `EventTimeMS`) instead when possible.

# Example

Use with `Unitful` to define `EventTime` of arbitrary units:

```jldoctest

using EventSpaceAlgebra, Unitful
EventTime(5u"ms_epoch")

true

# output

true
```

# TODO: Define `isless`, `isapprox` and perhaps `isequal` for the following code to run. Please go to `comparisonop.jl`.

Conversion between `ms_epoch` and `jd`:

```
evt_ms = EventTimeMS(123)
evt_jd = uconvert(u"jd", evt_ms.value)
EventTime(evt_jd) == evt_ms

# output

true # FIXME: not a jldoctest yet.
```

"""
struct EventTime{T,U} <: TemporalCoordinate{T,U}
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
`EventTimeMS` is the abstract type for dispatching `EventTime` of `typeof(ms_epoch)`.

See https://docs.julialang.org/en/v1/manual/types/#UnionAll-Types
and https://docs.julialang.org/en/v1/manual/types/#Type-Aliases

Noted that since `EventTimeMS` is abstract, the `EventTime` interface is not available.

```jldoctest
julia> using EventSpaceAlgebra, Unitful

julia> EventTimeMS(5u"ms_epoch")
ERROR: MethodError: no method matching (EventTimeMS)(::Quantity{Int64, 𝐓, Unitful.FreeUnits{(ms_epoch,), 𝐓, nothing}})

julia> EventTimeMS(5.0u"ms_epoch") # Dispatched to `EventTime` method
ERROR: MethodError: no method matching (EventTimeMS)(::Quantity{Float64, 𝐓, Unitful.FreeUnits{(ms_epoch,), 𝐓, nothing}})
```

"""
EventTimeMS{T} = EventTime{T,typeof(ms_epoch)} where {T<:Real}

"""
`EventTimeMS(n::Real)`.

# Example

```jldoctest testmsep
using EventSpaceAlgebra, Unitful
EventTime(5, ms_epoch) == EventTimeMS(5)

# output

true
```

```jldoctest testmsep
typeof(EventTime(5, ms_epoch)) <: EventTimeMS

# output

true

```
"""
EventTimeMS(n::Real) = EventTime(Quantity(n, ms_epoch)) # `::Real` is critical otherwise it falls back to `EventTime`.

"""
# Example

Convert `DateTime` to `EventTimeMS`:

```jldoctest
julia> using Dates, EventSpaceAlgebra

julia> dt = DateTime(2022, 1, 1);

julia> EventTimeMS(dt) == EventTimeMS(Dates.datetime2epochms(dt))
true
```
"""
EventTimeMS(dt::DateTime) = EventTimeMS(Dates.datetime2epochms(dt))

# Explicitly define EventTimeJD
"""
`EventTimeJD` is the abstract type for dispatching `EventTime` of `typeof(jd)`.

See `EventTimeMS` for more information.
"""
EventTimeJD{T} = EventTime{T,typeof(jd)} where {T<:Real}
# It is equivalent:
# const EventTimeJD = EventTime{T,typeof(jd)} where {T<:Real}
# See https://docs.julialang.org/en/v1/manual/types/#UnionAll-Types

"""
`EventTimeJD(n::Real)`.

# Example

```jldoctest
using EventSpaceAlgebra
EventTime(5.1, jd) == EventTimeJD(5.1)

# output

true
```

```jldoctest
using EventSpaceAlgebra
typeof(EventTimeJD(5)) == typeof(EventTimeJD(5.0))

# output

false
```

```jldoctest testjd
julia> using EventSpaceAlgebra, Unitful
```

```jldoctest testjd
julia> a = EventTime(5.0, jd)
EventTimeJD{Float64}(5.0 jd)

julia> b = EventTime(5u"jd")
EventTimeJD{Int64}(5 jd)

julia> EventTimeJD{Int64}
EventTimeJD{Int64} (alias for EventTime{Int64, Unitful.FreeUnits{(jd,), 𝐓, nothing}})

julia> typeof(a) <: EventTimeJD
true

julia> typeof(b) <: EventTimeJD
true


julia> to_datetime(a)
-4713-11-29T12:00:00

julia> to_datetime(b)
-4713-11-29T12:00:00
```
"""
EventTimeJD(n::Real) = EventTime(Quantity(n, jd))


"""
# Example

Convert `DateTime` to `EventTimeJD`:

```jldoctest
julia> using Dates, EventSpaceAlgebra

julia> dt = DateTime(2022, 1, 1);

julia> EventTimeJD(dt) == EventTimeJD(Dates.datetime2julian(dt))
true
```
"""
EventTimeJD(dt::DateTime) = EventTimeJD(Dates.datetime2julian(dt))



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

const epoch_julian_diff_ms = DateTime(0000, 1, 1) - DateTime(-4713, 11, 24, 12, 00, 00)

"""
Convert `EventTimeMS` to `EventTimeJD`:

# Example

```jldoctest
julia> using Dates, EventSpaceAlgebra, Unitful

julia> EventTimeJD{Float64}(EventTimeMS(0)) == EventTimeJD(DateTime(0000, 1, 1))
true
```

"""
function EventTimeJD{T}(evt::EventTimeMS) where {T}
    EventTime{T,typeof(jd)}(uconvert(jd, evt.value + epoch_julian_diff_ms))
end

"""
Convert `EventTimeJD` to `EventTimeMS`:

# Example

```jldoctest
julia> using Dates, EventSpaceAlgebra, Unitful

julia> dt = DateTime(-4713, 11, 24, 12, 00, 00) - DateTime(0000, 1, 1);

julia> EventTimeMS{Int}(EventTimeJD(0)) == EventTimeMS(dt.value)
true
```

"""
function EventTimeMS{T}(evt::EventTimeJD) where {T}
    EventTime{T,typeof(ms_epoch)}(uconvert(ms_epoch, evt.value) - epoch_julian_diff_ms)
end
