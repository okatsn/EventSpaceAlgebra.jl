# # General operations and special cases (no needs to handle commutative properties)

# ## Error handling
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


# ## Comparing to `DateTime`
# Here I explicitly define all possible combinations, in order to strictly limit the t1, t2 to be additionally processed
# on only these specific events. I cannot find any other efficient way (that not use if...else) to dispatch the events
# where only "either" of the input is DateTime (where the other must not), without colliding to existing methods.
for op in (:(==), :isless)
    @eval function Base.$op(t1::TemporalCoordinate, t2::DateTime)
        $op(to_datetime(t1), t2)
    end

    @eval function Base.$op(t1::DateTime, t2::TemporalCoordinate)
        $op(t1, to_datetime(t2))
    end
end
