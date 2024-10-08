## KEYNOTE (Old): You don't need to define `isequal` when ValueUnit is immutable.
# - By default, `isequal` calls `==`. So I only need to define custom `==`.
# - (By default) `==` and thus `isequal` depend on `hash`
# - `DataFrames.groupby` also depends on `hash`
# - `mutable struct`s are hashed by reference, thus `ValueUnit(1, Degree) == ValueUnit(1, Degree)` returns `false` for `mutable struct ValueUnit ...end`.
# - `groupby` also group different constructs of the same `mutable struct`s into different groups, even they hold exactly the same contents.
# - I failed to write a `hash` for my AbstractSpace, as below. However, problem solved when I change ValueUnit to `mutable struct`.
# - See https://stackoverflow.com/questions/72479616/why-does-adding-mutable-produce-different-hash-values
# function Base.hash(as1::AbstractSpace)
#     h1 = hash(get_value(as1))
#     hash(get_unit(as1), h1)
# end

# TODO: define `isapprox` and `isless` ... for eventTime-wise, Latitude-wise and Longitude-wise comparison.


# # Comparison between the same unit type
function Base.isapprox(t1::EventTime{<:Real,U}, t2::EventTime{<:Real,U}) where {U}
    isapprox(t1.value, t2.value)
end

function Base.:(==)(t1::EventTime{<:Real,U}, t2::EventTime{<:Real,U}) where {U}
    ==(t1.value, t2.value)
end


# # Comparison between two different unit types
function Base.isapprox(t1::TemporalCoordinate{<:Real,U1}, t2::TemporalCoordinate{<:Real,U2}) where {U1,U2}
    unit1 = Unitful.unit(t1.value)
    isapprox(t1.value, uconvert(unit1, t2.value))
end

function Base.:(==)(t1::TemporalCoordinate{<:Real,U1}, t2::TemporalCoordinate{<:Real,U2}) where {U1,U2}
    unit1 = Unitful.unit(t1.value)
    isapprox(t1.value, uconvert(unit1, t2.value))
end # FIXME


# # Comparing to `DateTime`
function Base.:(==)(t1::TemporalCoordinate, t2::DateTime)
    ==(to_datetime(t1), t2)
end

# For commutative property.

Base.:(==)(t2::DateTime, t1::TemporalCoordinate) = isequal(t1, t2)
# TODO: Define `isless`, `isapprox` and perhaps `isequal` for the following code to run. Please go to `comparisonop.jl`.
