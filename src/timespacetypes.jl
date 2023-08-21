struct Degree <: Angular end
struct JulianDay <: EpochTime end


"""
`ValueUnit` is a simple mutable concrete structure that holds a `value` and the `unit::GeneralUnit` of the value.
"""
mutable struct ValueUnit
    value
    unit::Type{<:GeneralUnit}
end

get_unit(S::AbstractSpace) = get_unit(S.vu)
get_value(S::AbstractSpace) = get_value(S.vu)
get_unit(vu::ValueUnit) = vu.unit
get_value(vu::ValueUnit) = vu.value

"""
The interface for constructing any concrete type belongs to `GeneralSpace`.

# Example
```jldoctest
Longitude(ValueUnit(1, Degree)) == GeneralSpace(Longitude, 1, Degree)

# output

true
```
"""
function GeneralSpace(t::Type{<:GeneralSpace}, value, unit)
    t(ValueUnit(value, unit))
end

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



# Distance(value, unit::Type{<:Angular}) = AngularDistance(value, unit)
# Distance(value, unit::Type{<:EpochTime}) = EpochDuration(value, unit)

"""
Function `disttype` defines the one-to-one correspondance between `U::GeneralUnit` and `T::Distance`; it returns the type/constructor `T`.

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
3. `distype(::Type{<:GeneralUnitOrOneOfItsAbstractType}) = NewDistance`


See also: `disttype`.
"""
function Distance(value, unit)
    t = disttype(unit)
    t(ValueUnit(value, unit))
end

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
