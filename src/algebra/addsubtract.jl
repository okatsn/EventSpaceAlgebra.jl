

"""
`Base.:-(t1::EventTime, t2::EventTime)`.
Abstract subtraction between two `EventTime`, which are converted to `DateTime` and output their subraction results.
"""
function Base.:-(t1::EventTime, t2::EventTime)
    to_datetime(t1) - to_datetime(t2)
end

function Base.:-(t1::EventTimeMS{T}, Δt::U) where {T} where {U<:Dates.AbstractTime}
    EventTimeMS{T}(t1.value - Quantity(Δt))
end

function Base.:-(t1::EventTimeJD{T}, Δt::U) where {T} where {U<:Dates.AbstractTime}
    EventTimeJD{T}(t1.value - Quantity(Δt))
end


function Base.:+(t1::EventTimeMS{T}, Δt::U) where {T} where {U<:Dates.AbstractTime}
    EventTimeMS{T}(t1.value + Quantity(Δt))
end

function Base.:+(t1::EventTimeJD{T}, Δt::U) where {T} where {U<:Dates.AbstractTime}
    EventTimeJD{T}(t1.value + Quantity(Δt))
    # CHECKPOINT for the failure: This failed because Quantity(Δt) is of dimension 𝐓, whereas `t1.value` is of dimension `𝐓^2`.
    # Basically, simple `32u"°F" + 1u"°F"` failed
end

# Ensure the commutative property:
Base.:+(Δt::U, t1::EventTime) where {U<:Dates.AbstractTime} = t1 + Δt


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
