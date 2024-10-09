# # General
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


# # Commutative

# # Comparing to `DateTime`
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


# # Spatial and Temporal coordinate comparison operation
for op in (:(==), :isapprox), AC in (:Latitude, :Longitude, :Depth, :EventTime)
    @eval function Base.$op(t1::$AC, t2::$AC)
        $op(t1.value, t2.value)
    end
end


# # Add

function Base.:+(t1::EventTime{T,U}, t2::Quantity) where {T} where {U}
    EventTime{T,U}(t1.value + t2)
end

function Base.:+(t1::EventTime{T,U}, Δt::Dates.AbstractTime) where {T} where {U}
    EventTime{T,U}(t1.value + Quantity(Δt))
end

# Ensure the commutative property:
Base.:+(Δt::Dates.AbstractTime, t1::EventTime) = t1 + Δt
