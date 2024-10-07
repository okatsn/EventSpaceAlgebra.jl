

# # For the temporal distance between two event.
# TODO: "-" functions for eventTime scale with eventTime of the same unit. (output: duration)
# TODO: "-" functions for eventTime scale with eventTime of a different unit. (output: duration)
function Base.:-(t1::EventTime, t2::EventTime)
    to_datetime(t1) - to_datetime(t2)
end

get_val(t::EventTime) = t.value
get_val(t::Dates.AbstractTime) = t

function Base.:+(t1::EventTime, Δt::U) where {U<:Dates.AbstractTime}
    EventTime(uconvert(ms_epoch, get_val(t1) + get_val(Δt)))
end

function Base.:+(t1::EventTime, Δt::U) where {U<:Dates.AbstractTime}
    EventTime(uconvert(jd, get_val(t1) + get_val(Δt)))
end

# Ensure the commutative property:
Base.:+(Δt::U, t1::EventTime) where {U<:Dates.AbstractTime} = t1 + Δt


# # For referenced temporal and spatial points:
# TODO: "+" and "-" functions for eventTime scale with duration. (output: DateTime)



# TODO: Test output types above.



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
