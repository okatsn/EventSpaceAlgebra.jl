@testset "Commutative property" begin
    using Dates
    Δts = [Hour(5), Second(19767056), Day(78999), 5.2u"hr", 3u"s", 9887u"d"]
    ts = [EventTimeMS(5990), EventTimeJD(7.892), EventTimeMS(1.599), EventTimeJD(1 // 3)]
    for t in ts, Δt in Δts
        @test (t + Δt) == (Δt + t)
        @test typeof(t) == typeof((t + Δt))
        @test_throws MethodError Δt - t # Noted that subtraction is not commutative!
        @test typeof(t) == typeof((t - Δt))
    end

    @test EventTimeMS(5990) - Second(1) == EventTimeMS(4990)
    @test EventTimeMS(5990) - 1u"s" == EventTimeMS(4990)
    @test EventTimeJD(5990) - Day(990) == EventTimeJD(5000)
    @test EventTimeJD(5990) - 990u"d" == EventTimeJD(5000)
    @test Day(990) + EventTimeJD(5000.5) == EventTimeJD(5990.5)
    @test 990u"d" + EventTimeJD(5000.5) == EventTimeJD(5990.5)

end

@testset "Test Add/Substract" begin
    using Dates
    Δt = 5998u"hr"
    dt = DateTime(2024, 10, 7)
    evt0 = EventTimeMS(dt)
    evt1 = EventTimeJD(dt) + Δt
    subtracted_t = (evt1 - evt0)
    @test isapprox(EventTimeJD(dt + subtracted_t), evt1)

    @test isapprox(EventTimeJD(dt) + Δt, EventTimeMS(dt) + Δt) # comparison between different unit will encounter promotion, which may result is numerical error.

    a = EventTimeJD(dt) - Δt
    b = EventTimeMS(dt) - Δt
    @test isapprox(a, b) # equality check will return false because of unit conversion.
    @test EventTimeJD(dt) == EventTimeMS(dt)

    @test_throws InexactError EventTimeMS(5) + 5.9u"ms"
    @test_throws InexactError EventTimeJD(5) + 43200u"s"
    @test_throws InexactError EventTimeMS(5) - 5.9u"ms"
    @test_throws InexactError EventTimeJD(5) - 43200u"s"
    @test EventTimeJD(5) + 86400u"s" == EventTimeJD(6)
    @test EventTimeJD(5) - 86400u"s" == EventTimeJD(4)

    # # Spatial
    @test Longitude(5u"°") - Longitude(1u"°") == 4u"°"
    @test Longitude(5.0u"°") - Longitude(1u"°") == 4.0u"°"
    @test Latitude(5u"°") - Latitude(1u"°") == 4u"°"
    @test Latitude(5.0u"°") - Latitude(1u"°") == 4.0u"°"
    @test_throws MethodError Longitude(5u"°") + Longitude(1u"°")
    @test_throws MethodError Latitude(5u"°") + Latitude(1u"°")
    @test_throws MethodError Longitude(5u"°") - Latitude(1u"°")
    @test_throws MethodError Latitude(5u"°") - Longitude(1u"°")

    # Coordinate of different type should not be subtractable
    @test Depth(5u"m") - Depth(1u"m") == 4u"m"
    @test Depth(5.0u"m") - Depth(1u"m") == 4.0u"m"
    @test_throws MethodError Depth(5u"m") + Depth(1u"m")

    # `+` and `-` methods on spatial coordinates with quantity.
    @test 50u"m" + Depth(5u"km") == Depth(5u"km") + 50u"m" == Depth(5050u"m")
    @test Depth(5u"km") - 50u"m" == Depth(4950u"m")
    @test 10u"°" + Longitude(20u"°") == Longitude(20u"°") + 10u"°" == Longitude(30u"°")
    @test 10u"°" + Latitude(20u"°") == Latitude(20u"°") + 10u"°" == Latitude(30u"°")
    @test Longitude(20u"°") - 10u"°" == Longitude(10u"°")
    @test Latitude(20u"°") - 10u"°" == Latitude(10u"°")
    @test (1 // 2) * π * u"rad" + Longitude(20u"°") == Longitude(20u"°") + (1 // 2) * π * u"rad" == Longitude(110u"°")
    @test (1 // 2) * π * u"rad" + Latitude(0u"°") == Latitude(0u"°") + (1 // 2) * π * u"rad" == Latitude(90u"°")
    @test Longitude(180 * u"°") - (1 // 2) * π * u"rad" == Longitude(90u"°")
    @test Latitude(90u"°") - (1 // 2) * π * u"rad" == Latitude(0u"°")
    # TODO: Longitude over 180°, Latitude for over 90° are not tested yet.

    # # It is intended that deg_E/N is designed to be not compatible with Longitude/Latitude.
    # Must to fail if the dimension is different:
    @test_throws MethodError Longitude(32u"°") + 8u"deg_N"
    @test_throws MethodError Latitude(32u"°") + 8u"deg_E"
    # Designed to make code to be easily maintainable and avoid ambiguity:
    @test_throws UnitIncompatible Longitude(32u"°") + 8u"deg_E" == Longitude(40u"°")
    @test_throws UnitIncompatible Latitude(32u"°") + 8u"deg_N" == Latitude(40u"°")
    @test_throws UnitIncompatible Longitude(32u"°") - 8u"deg_E" == Longitude(24u"°")
    @test_throws UnitIncompatible Latitude(32u"°") - 8u"deg_N" == Latitude(24u"°")

    apt = ArbitraryPoint(EventTimeJD(5), Latitude(32u"°"), Longitude(24u"°"), nothing, Depth(5u"km"))

    @test_throws MethodError apt + 8u"deg_E"
    @test_throws MethodError apt + 8u"deg_N"


    # Test shifting Latitude by +3 deg_N
    shift!(apt, 3u"deg_N")
    @test apt.lat == Latitude(35u"°")   # 32° + 3°N = 35°

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Test shifting Latitude by -5 deg_N
    shift!(apt, -5u"deg_N")
    @test apt.lat == Latitude(27u"°")   # 32° + (-5°N) = 27°

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Test shifting Longitude by +10 deg_E
    shift!(apt, 10u"deg_E")
    @test apt.lon == Longitude(34u"°")  # 24° + 10°E = 34°

    # Reset apt.lon to 24°
    apt.lon = Longitude(24u"°")

    # Test shifting Longitude by -15 deg_E
    shift!(apt, -15u"deg_E")
    @test apt.lon == Longitude(9u"°")   # 24° + (-15°E) = 9°

    # Reset apt.lon to 24°
    apt.lon = Longitude(24u"°")

    # Test shifting Depth by +2 dep_km
    shift!(apt, 2u"dep_km")
    @test apt.depth == Depth(7u"km")    # 5 km + 2 km = 7 km

    # Reset apt.depth to 5 km
    apt.depth = Depth(5u"km")

    # Test shifting Depth by -3 dep_km
    shift!(apt, -3u"dep_km")
    @test apt.depth == Depth(2u"km")    # 5 km + (-3 km) = 2 km

    # Reset apt.depth to 5 km
    apt.depth = Depth(5u"km")

    # Test shifting with zero units (no changes should occur)
    shift!(apt, 0u"deg_N")
    @test apt.lat == Latitude(32u"°")

    shift!(apt, 0u"deg_E")
    @test apt.lon == Longitude(24u"°")

    shift!(apt, 0u"dep_km")
    @test apt.depth == Depth(5u"km")

    # Test shifting with incompatible units (should throw errors)
    @test_throws MethodError shift!(apt, 5u"kg")
    @test_throws MethodError shift!(apt, 5u"m")
    @test_throws MethodError shift!(apt, 5u"s")

    # Test shifting Latitude beyond valid range (depending on implementation)
    apt.lat = Latitude(85u"°")
    shift!(apt, 10u"deg_N")
    @test apt.lat == Latitude(95u"°")  # 85° + 10°N = 95°

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Test shifting Longitude beyond 360 degrees (assuming no wrapping)
    apt.lon = Longitude(350u"°")
    shift!(apt, 20u"deg_E")
    @test apt.lon == Longitude(370u"°") # 350° + 20°E = 370°

    # Reset apt.lon to 24°
    apt.lon = Longitude(24u"°")

    # Test shifting Depth to negative value (if negative depth is allowed)
    apt.depth = Depth(5u"km")
    shift!(apt, -10u"dep_km")
    @test apt.depth == Depth(-5u"km")   # 5 km + (-10 km) = -5 km

    # Reset apt.depth to 5 km
    apt.depth = Depth(5u"km")

    # Test multiple shifts sequentially
    shift!(apt, 5u"deg_N")
    shift!(apt, 10u"deg_E")
    shift!(apt, 3u"dep_km")
    @test apt.lat == Latitude(37u"°")   # 32° + 5°
    @test apt.lon == Longitude(34u"°")  # 24° + 10°
    @test apt.depth == Depth(8u"km")    # 5 km + 3 km

    # Reset apt to original values
    apt.lat = Latitude(32u"°")
    apt.lon = Longitude(24u"°")
    apt.depth = Depth(5u"km")

    # Test shifting with invalid units (should throw errors)
    @test_throws MethodError shift!(apt, 5u"kg*m/s^2")
    @test_throws MethodError shift!(apt, 5u"Hz")

    # Ensure other fields remain unchanged
    apt.time = EventTimeJD(5)
    apt.mag = EventMagnitude{RichterMagnitude}(3.0)

    shift!(apt, 5u"deg_N")
    @test apt.time == EventTimeJD(5)
    @test apt.mag == EventMagnitude{RichterMagnitude}(3.0)

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # # Test shifting with NaN (should throw an error)
    # @test_throws MethodError shift!(apt, NaN * u"deg_N")

    # # Test shifting with Inf (should throw an error)
    # @test_throws MethodError shift!(apt, Inf * u"deg_N")

    # Test that shift! modifies the original point in-place
    apt.lat = Latitude(32u"°")
    shift!(apt, 5u"deg_N")
    @test apt.lat == Latitude(37u"°")   # Should be updated in-place

    # Ensure shift! returns nothing (since it's an in-place operation)
    @test shift!(apt, 5u"deg_N") == nothing

    # Test shifting by a large negative number
    apt.lat = Latitude(32u"°")
    shift!(apt, -100u"deg_N")
    @test apt.lat == Latitude(-68u"°")  # 32° + (-100°) = -68°

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Test shifting by a large positive number
    shift!(apt, 200u"deg_N")
    @test apt.lat == Latitude(232u"°")  # 32° + 200° = 232°

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Test shifting with a zero unit of an invalid dimension (should throw an error)
    @test_throws MethodError shift!(apt, 0u"kg")

    # Test shifting with multiple units in one call (if supported)
    # Assuming shift! can handle multiple units
    # function shift!(pt::ArbitraryPoint, uts::Vararg{MySpecializedUnits})
    #     for ut in uts
    #         shift!(pt, ut)
    #     end
    # end

    # Test multiple shifts in one call (if supported)
    shift!(apt, 5u"deg_N", 10u"deg_E", 3u"dep_km")
    @test apt.lat == Latitude(37u"°")
    @test apt.lon == Longitude(34u"°")
    @test apt.depth == Depth(8u"km")

    # Reset apt to original values
    apt.lat = Latitude(32u"°")
    apt.lon = Longitude(24u"°")
    apt.depth = Depth(5u"km")

    # Test shifting magnitude (should throw an error if not supported)
    @test_throws MethodError shift!(apt, 0.5u"deg_N")  # Assuming mag is not shifted

    # Test shifting time (should throw an error if not supported)
    @test_throws MethodError shift!(apt, 10u"deg_N")   # Assuming time is not shifted

    # Test shifting with invalid unit type (e.g., string)
    @test_throws MethodError shift!(apt, "5 deg_N")

    # Test shifting with mismatched unit (e.g., shifting depth with deg_E)
    @test_throws MethodError shift!(apt, 5u"deg_E")    # Should not affect depth

    # Test that other coordinates remain unchanged when shifting one coordinate
    shift!(apt, 5u"deg_N")
    @test apt.lat == Latitude(37u"°")
    @test apt.lon == Longitude(24u"°")   # Should remain unchanged
    @test apt.depth == Depth(5u"km")     # Should remain unchanged

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Ensure that after shifting, the original apt is modified
    @test apt.lat == Latitude(32u"°")
    shift!(apt, 5u"deg_N")
    @test apt.lat == Latitude(37u"°")  # Confirmed that apt is modified

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Edge case: Shift with unitless number (should throw an error)
    @test_throws MethodError shift!(apt, 5)  # No units provided

    # Edge case: Shift with incorrect unit symbol
    @test_throws MethodError shift!(apt, 5u"deg_N")  # Incorrect unit symbol

    # Test shifting with extremely large numbers
    shift!(apt, 1e6u"deg_N")
    @test apt.lat == Latitude(1.000032e6u"°")  # 32° + 1e6°N

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Test shifting with extremely small numbers
    shift!(apt, 1e-6u"deg_N")
    @test apt.lat ≈ Latitude(32.000001u"°")   # 32° + 1e-6°N

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Test shifting with non-integer units
    shift!(apt, 2.5u"deg_N")
    @test apt.lat == Latitude(34.5u"°")       # 32° + 2.5°N

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Test shifting with multiple shifts of the same unit
    shift!(apt, 3u"deg_N")
    shift!(apt, 4u"deg_N")
    @test apt.lat == Latitude(39u"°")         # 32° + 3° + 4° = 39°

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Test that shift! handles units with dimensions but zero magnitude
    shift!(apt, 0u"deg_N")
    @test apt.lat == Latitude(32u"°")         # No change

    # Test shifting when coordinate is at boundary value
    apt.lat = Latitude(90u"°")
    shift!(apt, 0u"deg_N")
    @test apt.lat == Latitude(90u"°")         # No change

    # Shift beyond boundary (depending on implementation)
    shift!(apt, 5u"deg_N")
    @test apt.lat == Latitude(95u"°")         # 90° + 5°N = 95°

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Test shifting with a unit that has additional units (e.g., deg_N * m)
    @test_throws MethodError shift!(apt, (5u"deg_N") * 1u"m")  # Should throw an error

    # Test shifting with negative zero
    shift!(apt, -0.0u"deg_N")
    @test apt.lat == Latitude(32u"°")         # No change

    # Test shifting with subnormal numbers (very small numbers)
    shift!(apt, 1e-308u"deg_N")
    @test apt.lat ≈ Latitude(32u"°")          # Change is negligible

    # Ensure the shift! function does not affect unrelated instances
    apt2 = ArbitraryPoint(EventTimeJD(5), Latitude(45u"°"), Longitude(60u"°"), nothing, Depth(10u"km"))
    shift!(apt, 5u"deg_N")
    @test apt2.lat == Latitude(45u"°")        # Should remain unchanged

    # Test shifting multiple times and verify cumulative effect
    shift!(apt, 2u"deg_N")
    shift!(apt, -3u"deg_N")
    @test apt.lat == Latitude(34u"°")         # 32° + 5° + 2° - 3° = 36°, but we already had 37°, so total is 37° + 2° - 3° = 36°

    # Correcting previous cumulative calculation
    # Since apt.lat was at 37° after previous shifts
    # So after shift!(apt, 2u"deg_N"), apt.lat == 39°
    # Then shift!(apt, -3u"deg_N"), apt.lat == 36°
    @test apt.lat == Latitude(39u"°")         # After adding 2°
    @test apt.lat == Latitude(36u"°")         # After subtracting 3°

    # Reset apt.lat to 32°
    apt.lat = Latitude(32u"°")

    # Final test: Ensure original apt is correctly modified after all operations
    @test apt.lat == Latitude(32u"°")
    shift!(apt, 10u"deg_N")
    @test apt.lat == Latitude(42u"°")

    #     @test_throws EventSpaceAlgebra.CoordinateMismatch Coordinate(Longitude, 121.33, Degree) - Coordinate(Latitude, 22.3, Degree)
    #     @test_throws EventSpaceAlgebra.CoordinateMismatch Coordinate(Longitude, 121.33, Degree) - Coordinate(EventTime, 22.3, JulianDay)

    #     # Distance substracted by Coordinate is unreasonable
    #     @test_throws EventSpaceAlgebra.CoordinateMismatch Distance(121.33, Degree) - Coordinate(Latitude, 22.3, Degree)
    #     @test_throws EventSpaceAlgebra.CoordinateMismatch Distance(121.33, JulianDay) - Coordinate(EventTime, 22.3, JulianDay)

    #     # test addition
    #     @test_throws EventSpaceAlgebra.UnitMismatch EventSpaceAlgebra._create_add(
    #         Longitude(1.1, Degree),
    #         EventTime(1, JulianDay)
    #     )
    #     cs = [Longitude, Latitude, EventTime]
    #     ut = [Degree, Degree, JulianDay]
    #     for (constructor, unit) in zip(cs, ut)
    #         @test_throws EventSpaceAlgebra.CoordinateMismatch constructor(1, unit) + constructor(1, unit)
    #     end

    #     c1s = [Longitude, Latitude, EventTime, Distance]
    #     c2s = [Distance, Distance, Distance, Distance]
    #     uts = [Degree, Degree, JulianDay, Degree]
    #     for (c1, c2, unit) in zip(c1s, c2s, uts)
    #         @test isequal(c1(1, unit) + c2(1, unit), c1(2, unit))
    #     end
end
