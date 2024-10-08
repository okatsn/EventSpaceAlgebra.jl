"""
Any concrete type `::EventCoordinate` should be constructed as a `struct` with single field `value` of `Unitful.Quantity`, because ...
"""
# TODO: this interface is used in extending fundamental method such as `isless` and `isapprox`.
abstract type EventCoordinate end

abstract type TemporalCoordinate{T,U} <: EventCoordinate end

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

Noted that `ms_epoch` is defined as an affine unit that against `Unitful.ms`. That is, `uconvert` between `ms` and `ms_epoch` is exactly affined as-is.
```jldoctest
julia> using EventSpaceAlgebra, Unitful

julia> isequal(EventTimeMS(5), EventTime(5u"ms"))
true

julia> isequal(Quantity(5u"ms_epoch"), Quantity(5u"ms"))
true
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



# TODO: Use Holy trait for dispatching "spatial" (e.g., Longitude) and "temporal" (e.g., eventTime) Coordinate.



function EventTimeJD{T}(evt::EventTimeMS) where {T}
    EventTime{T,typeof(jd)}(uconvert(jd, evt.value))
end


function EventTimeMS{T}(evt::EventTimeJD) where {T}
    EventTime{T,typeof(ms_epoch)}(uconvert(ms_epoch, evt.value))
end
