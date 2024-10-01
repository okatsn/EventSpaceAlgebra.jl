# TODO: "+" functions for eventTime scale with duration.
# TODO: "+" functions for Longitude (Latitude) with Angle units.
# TODO: "-" functions for eventTime scale with eventTime of the same unit. (output: duration)


# TODO: "-" functions for eventTime scale with eventTime of a different unit. (output: duration)
function Base.:-(t1::EventTime{U1}, t2::EventTime{U2}) where {U1,U2}
    # Convert t2 to the unit of t1
    t2_converted = EventTime{U1}(uconvert(U1, t2.value))
    Duration{U1}(t1.value - t2_converted.value)
end



# TODO: "-" functions for eventTime scale with duration. (output: eventTime)
# TODO: "-" functions for Longitude (Latitude) with Longitude (Latitude) of the same unit. (output: Quantity of unit Angle)
# TODO: "-" functions for Longitude (Latitude) with Longitude (Latitude) of a different unit. (output: Quantity of unit Angle)
# TODO: "-" functions for Longitude (Latitude) with Angle units. (output: Longitude and Latitude)
# TODO: Test output types above.
