@testset "timespacetypes.jl" begin
    # `sameunit` returns true for any arbitrary two concrete construct of `AbstractSpace`.
    @test EventSpaceAlgebra.sameunit(
        Longitude(1, Degree), Longitude(2, Degree)
    )
    @test EventSpaceAlgebra.sameunit(
        Longitude(1, Degree), Latitude(2, Degree)
    )
    @test EventSpaceAlgebra.sameunit(
        Longitude(1, Degree), Distance(2.3, Degree)
    )
    @test EventSpaceAlgebra.sameunit(
        EventTime(1, JulianDay), Distance(2.3, JulianDay)
    )
    @test EventSpaceAlgebra.sameunit(
        Distance(1, Degree), Coordinate(Latitude, 1, Degree)
    )
    @test_throws EventSpaceAlgebra.UnitMismatch EventSpaceAlgebra.sameunit(
        Distance(1, Degree), EventTime(1, JulianDay)
    )
    @test_throws EventSpaceAlgebra.UnitMismatch EventSpaceAlgebra.sameunit(
        Distance(1, Degree), Distance(1, JulianDay)
    )
    # Test `Distance` constructor
    @test Distance(2.3, Degree) == AngularDistance(ValueUnit(2.3, Degree))

    # Test `sameunit` error
    @test_throws EventSpaceAlgebra.UnitMismatch EventSpaceAlgebra.sameunit(
        Coordinate(EventTime, 1, JulianDay), Coordinate(Latitude, 2, Degree)
    )

    # Test `isless`
    @test isless(
        Coordinate(Latitude, 1, Degree), Coordinate(Latitude, 2, Degree)
    )
    @test_throws MethodError isless(
        Coordinate(Longitude, 1, Degree), Coordinate(Latitude, 1, Degree)
    ) # Longitude and Latitude is not comparable in size even when they are of the same unit

    @test isapprox(
        Coordinate(Longitude, 121.33, Degree) - Coordinate(Longitude, 110.0, Degree), Distance(11.33, Degree)
    )
    @test isapprox(
        Coordinate(Longitude, 121.33, Degree) - Distance(110.0, Degree), Distance(11.33, Degree)
    )
    @test isapprox(
        Distance(121.33, Degree) - Distance(110.0, Degree), Distance(11.33, Degree)
    )

    @test isapprox(
        Coordinate(EventTime, 121.33, JulianDay) - Coordinate(EventTime, 110.0, JulianDay), Distance(11.33, JulianDay)
    )
    @test isapprox(
        Coordinate(EventTime, 121.33, JulianDay) - Distance(110.0, JulianDay), Distance(11.33, JulianDay)
    )
    @test isapprox(
        Distance(121.33, JulianDay) - Distance(110.0, JulianDay), Distance(11.33, JulianDay)
    )

    # test set_value!
    lg122 = Longitude(122, Degree)
    set_value!(lg122, 123)
    @test isequal(lg122, Longitude(123, Degree))

end

@testset "Test Addition" begin
    # Coordinate of different type should not be subtractable
    @test_throws EventSpaceAlgebra.CoordinateMismatch Coordinate(Longitude, 121.33, Degree) - Coordinate(Latitude, 22.3, Degree)
    @test_throws EventSpaceAlgebra.CoordinateMismatch Coordinate(Longitude, 121.33, Degree) - Coordinate(EventTime, 22.3, JulianDay)

    # Distance substracted by Coordinate is unreasonable
    @test_throws EventSpaceAlgebra.CoordinateMismatch Distance(121.33, Degree) - Coordinate(Latitude, 22.3, Degree)
    @test_throws EventSpaceAlgebra.CoordinateMismatch Distance(121.33, JulianDay) - Coordinate(EventTime, 22.3, JulianDay)

    # test addition
    @test_throws EventSpaceAlgebra.UnitMismatch EventSpaceAlgebra._create_add(
        Longitude(1.1, Degree),
        EventTime(1, JulianDay)
    )
    cs = [Longitude, Latitude, EventTime]
    ut = [Degree, Degree, JulianDay]
    for (constructor, unit) in zip(cs, ut)
        @test_throws EventSpaceAlgebra.CoordinateMismatch constructor(1, unit) + constructor(1, unit)
    end

    c1s = [Longitude, Latitude, EventTime, Distance]
    c2s = [Distance, Distance, Distance, Distance]
    uts = [Degree, Degree, JulianDay, Degree]
    for (c1, c2, unit) in zip(c1s, c2s, uts)
        @test isequal(c1(1, unit) + c2(1, unit), c1(2, unit))
    end
end
