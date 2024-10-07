

# # For the temporal distance between two event.
# TODO: "-" functions for eventTime scale with eventTime of the same unit. (output: duration)
# TODO: "-" functions for eventTime scale with eventTime of a different unit. (output: duration)

"""
`Base.:-(t1::EventTime, t2::EventTime)`.
Abstract subtraction between two `EventTime`, which are converted to `DateTime` and output their subraction results.
"""
function Base.:-(t1::EventTime, t2::EventTime)
    to_datetime(t1) - to_datetime(t2)
end

function Base.:-(t1::EventTimeMS{T}, Δt::U) where {T} where {U<:Dates.AbstractTime}
    EventTimeMS{T}(uconvert(ms_epoch, t1.value - Δt))
end

function Base.:-(t1::EventTimeJD{T}, Δt::U) where {T} where {U<:Dates.AbstractTime}
    EventTimeJD{T}(uconvert(jd, t1.value - Δt))
end


function Base.:+(t1::EventTimeMS{T}, Δt::U) where {T} where {U<:Dates.AbstractTime}
    EventTimeMS{T}(uconvert(ms_epoch, t1.value + Δt))
end

function Base.:+(t1::EventTimeJD{T}, Δt::U) where {T} where {U<:Dates.AbstractTime}
    EventTimeJD{T}(uconvert(jd, t1.value + Δt))
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
