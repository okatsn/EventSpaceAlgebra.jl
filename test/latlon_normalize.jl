@testset "latlon_normalize" begin
    using Statistics
    @test latlon_normalize(Longitude(10 * u"°")) == Longitude(10 * u"°")
    @test latlon_normalize(Longitude(-350 * u"°")) == Longitude(10 * u"°")
    @test latlon_normalize(Longitude(370 * u"°")) == Longitude(10 * u"°")
    @test latlon_normalize(Longitude(-190 * u"°")) == Longitude(170 * u"°")
    @test latlon_normalize(Longitude(10 * u"°")) == latlon_normalize(Longitude(-350 * u"°")) == latlon_normalize(Longitude(-710 * u"°"))
    @test latlon_normalize(Longitude(10 * u"°")) == latlon_normalize(Longitude(370 * u"°")) == latlon_normalize(Longitude(730 * u"°"))
    @test latlon_normalize(Longitude(170 * u"°")) == latlon_normalize(Longitude(-190 * u"°"))
    @test latlon_normalize(Latitude(80 * u"°")) == latlon_normalize(Latitude(-280 * u"°")) == latlon_normalize(Latitude(-640 * u"°"))
    @test latlon_normalize(Latitude(80 * u"°")) == latlon_normalize(Latitude(100 * u"°"))
    @test latlon_normalize(Latitude(-10 * u"°")) == latlon_normalize(Latitude(-170 * u"°"))

    v1 = [Latitude(80 * u"°"),
        Latitude(-280 * u"°"),
        Latitude(100 * u"°"),
        Latitude(-170 * u"°")]

    v2 = [Latitude(80 * u"°"),
        Latitude(80 * u"°"),
        Latitude(80 * u"°"),
        Latitude(-10 * u"°"),]

    @test latlon_normalize(v1[1]) == latlon_normalize(v2[1])
    @test latlon_normalize(v1[2]) == latlon_normalize(v2[2])
    @test latlon_normalize(v1[3]) == latlon_normalize(v2[3])
    @test latlon_normalize(v1[4]) == latlon_normalize(v2[4])

    # @test Latitude(-170 * u"°") / 17 == -10 / 17 * u"°"
    # @test mean(v1) == mean(v2)


    Latitude(-10 * u"°") / 5
end

@testset "Operation with TemporaryHolder" begin
    # # test where {T<:EventCoordinate}
    # @test_throws TypeError EventSpaceAlgebra.TemporaryHolder3{Int}(5u"m")
    # @test_throws TypeError EventSpaceAlgebra.TemporaryHolder3{Any}(5u"m")

    # # To revise
    # @test_throws MethodError Depth(5u"m") + Depth(1u"m")
    # @test_throws MethodError Longitude(5u"°") + Longitude(1u"°")
    # @test_throws MethodError Latitude(5u"°") + Latitude(1u"°")

    results = [
        Depth(5u"km") + Depth(1u"m"),
        Longitude(-10u"°") + Longitude(20u"°"),
        Latitude(-10u"°") + Latitude(20u"°"),
        Latitude(-10u"°") + Latitude(20u"°") + Latitude(7.0u"°"),
        # To make mean work, not only `+` but also `/` operation with Real number is required.
        Latitude(20u"°") / 2,
        Longitude(10u"°") / 3,
    ]
    wrong_answers = [
        Depth(5001u"m"),
        Longitude(10u"°"),
        Latitude(10u"°"),
        Latitude(17.0u"°"),
        Latitude(10u"°"),
        Longitude((10 / 3)u"°")
    ]
    for (r1, wa1) in zip(results, wrong_answers)
        @test r1 != wa1 # Depth + Depth is non-sense to be Depth, but
        @test r1.value == wa1.value # the quantity in side is the same.
    end


    th = Latitude(-10u"°") + Latitude(20u"°")
    @test_throws MethodError th + Longitude(20u"°")
    @test_throws MethodError th + Depth(20u"m")
    @test (th + th).value == 20u"°"

    # # test commutative property of +
    @test th + Latitude(2.0u"°") == Latitude(2.0u"°") + th
    @test (Latitude(2.0u"°") + th).value == 12.0u"°"
end

@testset "Mean and Standard Deviation of EventCoordinate" begin
    using Statistics
    v = [-5, 12, 33.5, 78.2, 99.8, 150.0, 190, 270, 360, 420, -32 / 3]
    vdeg = v .* u"°"
    vkm = v .* u"km"
    vlat = Latitude.(vdeg)
    vlon = Longitude.(vdeg)
    vdep = Depth.(vkm)

    @test mean(v) == mean(vlat).value.val
    @test mean(v) == mean(vlon).value.val
    @test mean(v) == mean(vdep).value.val
    @test std(v) == std(vlat).val
    @test std(v) == std(vlon).val
    @test std(v) == std(vdep).val
end
