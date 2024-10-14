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
