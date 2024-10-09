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
# TODO: Define `isless`, `isapprox` and perhaps `isequal` for the following code to run. Please go to `comparisonop.jl`.


# # Temporal units
# Comparison between the same unit type
# KEYNOTE: For meta programming, please refer quantities.jl of Unitful.
# - also see https://discourse.julialang.org/t/how-to-compare-two-vectors-whose-elements-are-equal-but-their-types-are-not-the-same/94309/3?u=okatsn

# # KEYNOTE: This section is disabled after methods are generated via the following "Spatial and Temporal coordinate comparison operation"
# for op in (:(==), :isapprox)
#     @eval function Base.$op(t1::EventTime{<:Real,U}, t2::EventTime{<:Real,U}) where {U}
#         $op(t1.value, t2.value)
#     end
# end
#
#
# # Comparison between two different unit types
# # - (This is superfluous, as it calls `$op` in the same way as above)
# for op in (:(==), :isapprox)
#     @eval function Base.$op(t1::TemporalCoordinate{<:Real,U1}, t2::TemporalCoordinate{<:Real,U2}) where {U1,U2}
#         $op(t1.value, t2.value)
#     end
#     # you don't need to do `unit1 = Unitful.unit(t1.value)` and then `isapprox(t1.value, uconvert(unit1, t2.value))`, because `Unitful` do promotion before comparison. See, isequal(x::Unitful.AbstractQuantity, y::Unitful.AbstractQuantity) for example.
# end


# # Comparing to `DateTime`
for op in (:(==), :isless)
    @eval function Base.$op(t1::TemporalCoordinate, t2::DateTime)
        $op(to_datetime(t1), t2)
    end

    @eval function Base.$op(t1::DateTime, t2::TemporalCoordinate)
        $op(t1, to_datetime(t2))
    end
end


# # Spatial and Temporal coordinate comparison operation
for op in (:(==), :isapprox, :isless), AC in (:Latitude, :Longitude, :Depth, :EventTime)
    @eval function Base.$op(t1::$AC, t2::$AC)
        $op(t1.value, t2.value)
    end
end


struct CoordinateMismatch <: Exception
    msg::String
end
CoordinateMismatch() = CoordinateMismatch("You should not compare different coordinate")
Base.showerror(io::IO, e::CoordinateMismatch) = print(io, e.msg)
# To use:
# throw(CoordinateMismatch("You should not compare different coordinate"))
# or
# throw(CoordinateMismatch())


for op in (:(==), :isapprox)
    @eval function Base.$op(t1::A, t2::B) where {A<:EventCoordinate} where {B<:EventCoordinate}
        throw(CoordinateMismatch())
    end
end
