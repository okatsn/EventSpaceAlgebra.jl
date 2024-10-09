# # For EventTime

"""
`Base.:-(t1::EventTime, t2::EventTime)`.
Abstract subtraction between two `EventTime`, which are converted to `DateTime` and output their subraction results.
"""

function Base.:-(t1::EventTime{T,U}, t2::Quantity) where {T} where {U}
    EventTime{T,U}(t1.value - t2)
end

function Base.:-(t1::EventTime{T,U}, Δt::Dates.AbstractTime) where {T} where {U}
    EventTime{T,U}(t1.value - Quantity(Δt))
end

function Base.:+(t1::EventTime{T,U}, t2::Quantity) where {T} where {U}
    EventTime{T,U}(t1.value + t2)
end

function Base.:+(t1::EventTime{T,U}, Δt::Dates.AbstractTime) where {T} where {U}
    EventTime{T,U}(t1.value + Quantity(Δt))
end

# Ensure the commutative property:
Base.:+(Δt::Dates.AbstractTime, t1::EventTime) = t1 + Δt

# Substract of the same type.
for op in (:-,), L in (:Latitude, :Longitude, :Depth) # This is similar to that in comparisonop.jl
    @eval function Base.$op(t1::$L, t2::$L)
        $op(t1.value, t2.value)
    end
end

# Add/Subtract of EventCoordinate by other types:

struct AlsoEventCoordinate end
struct NotEventCoordinate end

is_b_evt_coordinate(::Type{<:EventCoordinate}) = AlsoEventCoordinate()
is_b_evt_coordinate(::Type{<:Any}) = NotEventCoordinate() # anything else


# a is certainly EventCoordinate
for op in (:+, :-)
    @eval begin
        Base.$op(::AlsoEventCoordinate, a, b) = $op(a, b) # if b is also EventCoordinate, fall back to the operation of the same type (defined before; for `+`, there will be a MethodError since it is not defined)
        Base.$op(::NotEventCoordinate, a, b) = typeof(a).name.wrapper($op(a.value, b)) # if b is not EventCoordinate, do the calculation at the `Unitful.Quantity` level, then encapsule the results as `T::EventCoordinate`.

    end
    for L in (:Latitude, :Longitude, :Depth)
        @eval begin
            function Base.$op(a::$L, b)
                $L($op(is_b_evt_coordinate(typeof(b)), a, b))
            end
        end
    end
end

# For those who has commutative properties
for op in (:+,), L in (:Latitude, :Longitude, :Depth)
    @eval function Base.$op(b, a::$L)
        $op(is_b_evt_coordinate(typeof(b)), a, b)
    end
end


# # Postponed because of there is no immediate necessity.
# - "+" functions for eventTime scale with duration.
# - "-" functions for Longitude (Latitude) with Longitude (Latitude) of a different unit. (output: Quantity of unit Angle)
# - "-" functions for Longitude (Latitude) with Angle units. (output: Longitude and Latitude)


# # Unfinished codes:
# Latitude and Longitude operations
# function Base.:+(l::Longitude, delta::EventAngleDegree)
#     Longitude(l.value + delta)
# end

# function Base.:-(lat::Latitude{U}, delta::Quantity{<:Number,U}) where {U}
#     Latitude{U}(lat.value - delta)
# end

# # Longitude operations
# function Base.:+(lon::Longitude{U}, delta::Quantity{<:Number,U}) where {U}
#     Longitude{U}(lon.value + delta)
# end

# function Base.:-(lon::Longitude{U}, delta::Quantity{<:Number,U}) where {U}
#     Longitude{U}(lon.value - delta)
# end
