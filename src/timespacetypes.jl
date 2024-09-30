# # TODO: Define EventTime, Longitude, Latitude here.
# # TODO: Use holy trait to distinguish the class (EventTime, Longitude, Latitude here) and the class (time, angle), for the reason:
# - Previously, for every mutable operation (e.g., `+`), I needs to define separately; for example, `Base.:+(gs2::Distance, gs1::Coordinate)` and `Base.:+(gs1::Coordinate, gs2::Distance)`, where both output the same result of `Coordinate` plus `Distance`. See also the TODOs in addsubtract.jl

# # TODO: Define unit JulianDay, EpochMillisecond here.

# # TODO: Test:
# - Test Longitude(::Quantity) and Longitude(::Float64) construction in jldoctest.
# - Test EventTime + Duration, EventTime - EventTime (same unit), and EventTime - EventTime (different unit)
# - Test EventTime to DateTime conversion.

# # TODO: Whether to use mutable struct for eventTime, Longitude and Latitude.
