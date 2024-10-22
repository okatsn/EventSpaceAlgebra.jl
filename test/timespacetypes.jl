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
    #         Distance(1, Degree), Coordinate(Latitude, 1, Degree)
    #     )

    #     # Test `Distance` constructor
    #     @test Distance(2.3, Degree) == AngularDistance(ValueUnit(2.3, Degree))

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

end

@testset "spatial parametric types" begin
    # float v.s. int
    @test Longitude(0.5π * u"rad") == Longitude(90 * u"°")
    @test Longitude(1π * u"rad") == Longitude(180 * u"°")
    @test Longitude(180 * u"°") == Longitude(180.0 * u"°")
    @test Latitude(180 * u"°") == Latitude(180.0 * u"°")
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
