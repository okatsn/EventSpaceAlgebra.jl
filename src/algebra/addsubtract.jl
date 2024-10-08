

"""
`Base.:-(t1::EventTime, t2::EventTime)`.
Abstract subtraction between two `EventTime`, which are converted to `DateTime` and output their subraction results.
"""
function Base.:-(t1::EventTime, t2::EventTime)
    to_datetime(t1) - to_datetime(t2)
end

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


# # Postponed because of there is no immediate necessity.
# - "+" functions for eventTime scale with duration.
# - "+" functions for Longitude (Latitude) with Angle units.
# - "-" functions for Longitude (Latitude) with Longitude (Latitude) of the same unit. (output: Quantity of unit Angle)
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
