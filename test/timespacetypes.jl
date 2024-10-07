@testset "timespacetypes.jl" begin
    @test EventTime{Float64,typeof(u"jd")}(5u"jd") === EventTime(5.0u"jd")
    @test EventTime{Int,typeof(u"jd")}(5u"jd") === EventTime(5u"jd")
    @test EventTime{Float64,typeof(u"jd")} === EventTimeJD{Float64}
    @test EventTime{Int,typeof(u"jd")} === EventTimeJD{Int}

    @test EventTime{Float64,typeof(u"ms_epoch")}(5u"ms_epoch") === EventTime(5.0u"ms_epoch")
    @test EventTime{Int,typeof(u"ms_epoch")}(5u"ms_epoch") === EventTime(5u"ms_epoch")
    @test EventTime{Float64,typeof(u"ms_epoch")} === EventTimeMS{Float64}
    @test EventTime{Int,typeof(u"ms_epoch")} === EventTimeMS{Int}
    #     # `sameunit` returns true for any arbitrary two concrete construct of `AbstractSpace`.
    #     @test EventSpaceAlgebra.sameunit(
    #         Longitude(1, Degree), Longitude(2, Degree)
    #     )
    #     @test EventSpaceAlgebra.sameunit(
    #         Longitude(1, Degree), Latitude(2, Degree)
    #     )
    #     @test EventSpaceAlgebra.sameunit(
    #         Longitude(1, Degree), Distance(2.3, Degree)
    #     )
    #     @test EventSpaceAlgebra.sameunit(
    #         EventTime(1, JulianDay), Distance(2.3, JulianDay)
    #     )
    #     @test EventSpaceAlgebra.sameunit(
    #         Distance(1, Degree), Coordinate(Latitude, 1, Degree)
    #     )
    #     @test_throws EventSpaceAlgebra.UnitMismatch EventSpaceAlgebra.sameunit(
    #         Distance(1, Degree), EventTime(1, JulianDay)
    #     )
    #     @test_throws EventSpaceAlgebra.UnitMismatch EventSpaceAlgebra.sameunit(
    #         Distance(1, Degree), Distance(1, JulianDay)
    #     )
    #     # Test `Distance` constructor
    #     @test Distance(2.3, Degree) == AngularDistance(ValueUnit(2.3, Degree))

    #     # Test `sameunit` error
    #     @test_throws EventSpaceAlgebra.UnitMismatch EventSpaceAlgebra.sameunit(
    #         Coordinate(EventTime, 1, JulianDay), Coordinate(Latitude, 2, Degree)
    #     )

    #     # Test `isless`
    #     @test isless(
    #         Coordinate(Latitude, 1, Degree), Coordinate(Latitude, 2, Degree)
    #     )
    #     @test_throws MethodError isless(
    #         Coordinate(Longitude, 1, Degree), Coordinate(Latitude, 1, Degree)
    #     ) # Longitude and Latitude is not comparable in size even when they are of the same unit

    #     @test isapprox(
    #         Coordinate(Longitude, 121.33, Degree) - Coordinate(Longitude, 110.0, Degree), Distance(11.33, Degree)
    #     )
    #     @test isapprox(
    #         Coordinate(Longitude, 121.33, Degree) - Distance(110.0, Degree), Distance(11.33, Degree)
    #     )
    #     @test isapprox(
    #         Distance(121.33, Degree) - Distance(110.0, Degree), Distance(11.33, Degree)
    #     )

    #     @test isapprox(
    #         Coordinate(EventTime, 121.33, JulianDay) - Coordinate(EventTime, 110.0, JulianDay), Distance(11.33, JulianDay)
    #     )
    #     @test isapprox(
    #         Coordinate(EventTime, 121.33, JulianDay) - Distance(110.0, JulianDay), Distance(11.33, JulianDay)
    #     )
    #     @test isapprox(
    #         Distance(121.33, JulianDay) - Distance(110.0, JulianDay), Distance(11.33, JulianDay)
    #     )

    #     # test set_value
    #     lg122 = Longitude(122, Degree)
    #     @test isequal(set_value(lg122, 123), Longitude(123, Degree))

end

@testset "Comparison integrity" begin
    using Unitful
    @test isapprox(EventTimeMS(5), EventTimeMS(5.0))
    @test isapprox(EventTimeMS(5), EventTimeMS(5.0000000000001))
    @test isapprox(EventTimeJD(1 // 4), EventTimeJD(0.25))
    @test isequal(EventTimeMS(5), EventTimeMS(5.0))
    @test isequal(EventTimeJD(1 // 4), EventTimeJD(0.25))
    @test !isequal(EventTimeMS(5), EventTime(5u"ms")) # Arbitrary units should not be guaranteed.

    # TODO: The following tests should returns true.
    dt = DateTime(2021, 12, 21)
    @test isequal(EventTimeMS(dt), EventTimeJD(dt))
    @test isequal(EventTimeMS(dt), dt)
    @test isequal(EventTimeJD(dt), dt)
end

@testset "Commutative property" begin
    Δts = [Hour(5), Second(19767056), Day(78999)]
    ts = [EventTimeMS(5990), EventTimeJD(7.892), EventTimeMS(1.599), EventTimeJD(1 // 3)]
    for t in ts, Δt in Δts
        @test (t + Δt) == (Δt + t)
        @test typeof(t) == typeof((t + Δt))
        @test_throws MethodError Δt - t # Noted that subtraction is not commutative!
        @test typeof(t) == typeof((t - Δt))
    end

    @test EventTimeMS(5990) - Second(1) == EventTimeMS(4990)
    @test EventTimeJD(5990) - Day(990) == EventTimeJD(5000)

end

@testset "Test Add/Substract" begin
    using Dates
    Δt = Hour(5998)
    dt = DateTime(2024, 10, 7)
    evt0 = EventTimeMS(dt)
    evt1 = EventTimeJD(dt) + Δt
    subtracted_t = (evt1 - evt0)
    @test EventTimeJD(dt + subtracted_t) == evt1
    #     # Coordinate of different type should not be subtractable
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

@testset "DataFrame grouping" begin
    # using DataFrames
    # df = DataFrame(
    #     :Lat => repeat(22.1:0.1:22.3, inner=[4]),
    #     :Lon => repeat(122.1:0.1:122.4, outer=[3]),
    #     :Time => repeat(1.1:0.1:1.6, outer=[2]))

    # @test length(groupby(df, [:Lat])) == 3
    # @test length(groupby(df, [:Lon])) == 4
    # @test length(groupby(df, [:Time])) == 6

    # transform!(df, :Time => ByRow(x -> EventTime(x, JulianDay)); renamecols=false)
    # transform!(df, :Lat => ByRow(x -> Latitude(x, Degree)); renamecols=false)
    # transform!(df, :Lon => ByRow(x -> Longitude(x, Degree)); renamecols=false)
    # # hdf = nrow(df)

    # @test length(groupby(df, [:Lat])) == 3
    # @test length(groupby(df, [:Lon])) == 4
    # @test length(groupby(df, [:Time])) == 6

end
