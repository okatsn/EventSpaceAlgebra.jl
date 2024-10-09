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
    @test Depth(5u"km") + 50u"m" == Depth(5050u"m")
    @test Depth(5u"km") - 50u"m" == Depth(4950u"m")
    @test Longitude(20u"°") + 10u"°" == Longitude(30u"°")
    @test Latitude(20u"°") + 10u"°" == Latitude(30u"°")
    @test Longitude(20u"°") - 10u"°" == Longitude(10u"°")
    @test Latitude(20u"°") - 10u"°" == Latitude(10u"°")
    @test Longitude(20u"°") + (1 // 2) * π * u"rad" == Longitude(110u"°")
    @test Latitude(0u"°") + (1 // 2) * π * u"rad" == Latitude(90u"°")
    @test Longitude(180 * u"°") - (1 // 2) * π * u"rad" == Longitude(90u"°")
    @test Latitude(90u"°") - (1 // 2) * π * u"rad" == Latitude(0u"°")
    # TODO: Longitude over 180°, Latitude for over 90° are not tested yet.


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
