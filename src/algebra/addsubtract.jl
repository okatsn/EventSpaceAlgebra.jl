# # For EventTime

"""
`Base.:-(t1::EventTime, t2::EventTime)`.
Abstract subtraction between two `EventTime`, which are converted to `DateTime` and output their subraction results.
"""
# TODO: Rename "comparisonop.jl" as it includes EventTime-wise subtraction.

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
function Base.:+(t1::Quantity, t2::EventTime{T,U}) where {T} where {U}
    EventTime{T,U}(t2.value + t1)
end

# # Spatial Coordinate
# Must convert to degree before operation, because something like `2 * π * u"rad" + 1u"°"` returns Float64.

for op in (:+, :-), AC in (:Latitude, :Longitude, :Depth)
    @eval begin
        function Base.$op(t1::$AC, t2)
            $AC($op(t1.value, t2))
        end
        # only `+` is commutative.
        if $op == :+
            function Base.$op(t1, t2::$AC)
                $op(t2, t1)
            end
        end
        # only `Longitude/Latitude` needs unit conversion if t2 is of unit radian.
        if $AC in (:Longitude, :Latitude)
        else
            function Base.$op(t1::$AC, t2::EventAngleRadian)
                $op(t1, uconvert(u"°", t2))
            end
        end
    end
end


# # Postponed because of there is no immediate necessity.
# - "+" functions for eventTime scale with duration.
# - "+" functions for Longitude (Latitude) with Angle units.
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
