

# # For the temporal distance between two event.
# TODO: "-" functions for eventTime scale with eventTime of the same unit. (output: duration)
# TODO: "-" functions for eventTime scale with eventTime of a different unit. (output: duration)
function Base.:-(t1::EventTime{U1}, t2::EventTime{U2}) where {U1,U2}
    # Convert t2 to the unit of t1
    t2_converted = EventTime{U1}(uconvert(U1, t2.value))
    Duration{U1}(t1.value - t2_converted.value)
end

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
