"""
`ValueUnit` is a simple mutable concrete structure that holds a `value` and the `unit::GeneralUnit` of the value.
"""
struct ValueUnit
    value
    unit::Type{<:GeneralUnit}
end

get_unit(S::AbstractSpace) = get_unit(S.vu)
get_value(S::AbstractSpace) = get_value(S.vu)
get_unit(vu::ValueUnit) = vu.unit
get_value(vu::ValueUnit) = vu.value

set_value(vu::ValueUnit, val) = ValueUnit(val, vu.unit)
set_value(abss::AbstractSpace, val) = typeof(abss)(set_value(abss.vu, val))



"""
The interface for constructing any concrete type belongs to `Coordinate`.

# Example
```jldoctest
Longitude(ValueUnit(1, Degree)) == Coordinate(Longitude, 1, Degree)

# output

true
```
"""
function Coordinate(t::Type{<:Coordinate}, value, unit)
    t(ValueUnit(value, unit))
end



# # SECTION: Concrete struct of `Coordinate`
struct Longitude <: Spatial
    vu::ValueUnit
end

Longitude(v, u) = Longitude(ValueUnit(v, u))

struct Latitude <: Spatial
    vu::ValueUnit
end
Latitude(v, u) = Latitude(ValueUnit(v, u))

struct EventTime <: Temporal
    vu::ValueUnit
end
EventTime(v, u) = EventTime(ValueUnit(v, u))


# # SECTION: Concrete struct of `GeneralUnit`
struct Degree <: Angular end

"""
`struct JulianDay <: EpochTime end`.

# Example

```jldoctest x15aw
using Dates, EventSpaceAlgebra
evt = EventTime(2451545, JulianDay) # create an `EventTime` in absolute `JulianDay`.
DateTime(evt) # convert it to `DateTime`

# output

2000-01-01T12:00:00
```

```jldoctest x15aw
EventTime(2451545, JulianDay) + Distance(3, JulianDay) |> DateTime

# output
2000-01-04T12:00:00
```

"""
struct JulianDay <: EpochTime end
struct DummyDayForTest <: EpochTime end

# Distance(value, unit::Type{<:Angular}) = AngularDistance(value, unit)
# Distance(value, unit::Type{<:EpochTime}) = EpochDuration(value, unit)

"""
Function `disttype` defines the one-to-one correspondance between `U::GeneralUnit` and `T::Distance`; it returns the type/constructor `T`.
`disttype` is essential for `Distance` to construct an `Distance` struct.

List:
- `disttype(::Type{<:Angular}) = AngularDistance`
- `disttype(::Type{<:EpochTime}) = EpochDuration`

"""
disttype(::Type{<:Angular}) = AngularDistance
disttype(::Type{<:EpochTime}) = EpochDuration

"""
`Distance(value, unit)` construct a concrete struct of `Distance`.

# Example

```jldoctest
Distance(5, Degree) == AngularDistance(ValueUnit(5, Degree))

# output

true


```

# Add a new type `<: Distance`

"Constructor" `Distance` relies on `disttype`. Following the following steps to add new utilities:

1. ```
   struct NewDistance <: Distance
       vu::ValueUnit
   end
   ```
2. `struct NewDistUnit <: GeneralUnitOrOneOfItsAbstractType end`
3. `disttype(::Type{<:GeneralUnitOrOneOfItsAbstractType}) = NewDistance`


See also: `disttype`.
"""
function Distance(value, unit)
    t = disttype(unit)
    t(ValueUnit(value, unit))
end

# # SECTION: Concrete struct of `Distance`
struct AngularDistance <: Distance
    vu::ValueUnit
    # function AngularDistance(value, unit::Type{<:Angular})
    #     vu = ValueUnit(value, unit)
    #     new(vu)
    # end
end
AngularDistance(v, u) = AngularDistance(ValueUnit(v, u))

struct EpochDuration <: Distance
    vu::ValueUnit
    # function EpochDuration(value, unit::Type{<:EpochTime})
    #     vu = ValueUnit(value, unit)
    #     new(vu)
    # end
end
EpochDuration(v, u) = EpochDuration(ValueUnit(v, u))
