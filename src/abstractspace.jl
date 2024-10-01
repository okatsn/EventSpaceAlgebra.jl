"""
Abstract type `AbstractCoordinate` are the supertype for all dimension/coordinate specification, such as `Longitude`, `Latitude` and `EventTime`.
"""
abstract type AbstractCoordinate{U} end

struct EventTime{U} <: AbstractCoordinate{U}
    value::Quantity{Float64,U}
end

# # Constructor from DateTime to EpochMillisecond
# function EventTime(dt::DateTime, ::Type{EpochMillisecond})
#     epoch = DateTime(1970, 1, 1) # FIXME: epoch should be verified. (epoch - datetime2epochms(epoch))
#     delta_ms = Millisecond(dt - epoch)
#     EventTime{EpochMillisecond}(delta_ms.value * u"EpochMillisecond")
# end

# # Optional
# const EventTimeMS = EventTime{EpochMillisecond}


# # Constructor from DateTime to JulianDay
# function EventTime(dt::DateTime, ::Type{JulianDay})
#     jd_value = Dates.datetime2julian(dt)
#     EventTime{JulianDay}(jd_value * u"JulianDay")
# end

# TODO: Use Holy trait for dispatching "spatial" (e.g., Longitude) and "temporal" (e.g., eventTime) Coordinate.
