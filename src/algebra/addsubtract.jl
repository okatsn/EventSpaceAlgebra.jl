# # (This script is NOT included and remains as a space of pure comments.)
# # For EventTime

"""
`Base.:-(t1::EventTime, t2::EventTime)`.
Abstract subtraction between two `EventTime`, which are converted to `DateTime` and output their subraction results.
"""





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
