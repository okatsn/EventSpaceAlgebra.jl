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
    @test Depth(5u"m") + Depth(1u"m") == 6u"m"
    @test Longitude(5u"°") + Longitude(1u"°") == 6u"°"
    @test Latitude(5u"°") + Latitude(1u"°") == 6u"°"
    @test Latitude(-10u"°") + Latitude(-10u"°") + Latitude(-10u"°") == 3 * Latitude(-10u"°")
    results = [
        Depth(5u"km") + Depth(1u"m"),
        Longitude(-10u"°") + Longitude(20u"°"),
        Latitude(-10u"°") + Latitude(20u"°"),
        Latitude(-10u"°") + Latitude(20u"°") + Latitude(7.0u"°"),]
    wrong_answers = [
        Depth(5001u"m"),
        Longitude(10u"°"),
        Latitude(10u"°"),
        Latitude(17.0u"°"),
    ]

    for (r1, wa1) in zip(results, wrong_answers)
        @test r1 != wa1 # Depth + Depth is non-sense to be Depth, but
        @test r1 == wa1.value # the quantity should be the same.
    end


    latavg = (Latitude(-10u"°") + Latitude(20u"°")) / 2
    @test_throws Unitful.DimensionError latavg + Depth(20u"m")

    # # test commutative property of +
    @test latavg + Latitude(2.0u"°") == Latitude(2.0u"°") + latavg
    @test Latitude(2.0u"°") + latavg == 7.0u"°"
end

@testset "Mean and Standard Deviation of EventCoordinate" begin
    using Statistics
    v = [-5, 12, 33.5, 78.2, 99.8, 150.0, 190, 270, 360, 420, -32 / 3]
    vdeg = v .* u"°"
    vkm = v .* u"km"
    vlat = Latitude.(vdeg)
    vlon = Longitude.(vdeg)
    vdep = Depth.(vkm)

    @test mean(v) == mean(vlat).val
    @test mean(v) == mean(vlon).val
    @test mean(v) == mean(vdep).val
    @test std(v) == std(vlat).val
    @test std(v) == std(vlon).val
    @test std(v) == std(vdep).val


    @test mean(vdep) == sum(vdep) / length(vdep)
    @test mean(vlat) == sum(vlat) / length(vlat)
    @test mean(vlon) == sum(vlon) / length(vlon)


    # To make mean work, not only `+` but also `/` operation with Real number is required.

end

@testset "Spatial Coordinate Algebra" begin
    @test Latitude(20u"°") + Latitude(20u"°") == 2 * Latitude(20u"°")
    @test Longitude(20u"°") + Longitude(20u"°") == 2 * Longitude(20u"°")
    @test Depth(20u"m") + Depth(20u"m") == 2 * Depth(20u"m")
    @test 6710u"km" * uconvert(u"rad", 2 * Latitude(90u"°")) == 6710u"km" * π * u"rad"

    @test (Latitude(-10u"°") + Latitude(20u"°")) / 2 == (Latitude(-10u"°") + Latitude(20u"°")) * 0.5
    @test (Longitude(-10u"°") + Longitude(20u"°")) / 2 == (Longitude(-10u"°") + Longitude(20u"°")) * 0.5
    @test (Depth(20u"m") + Depth(20u"m")) / 2 == 0.5 * (Depth(20u"m") + Depth(20u"m"))

    @test 1 * Latitude(10 * u"°") + Longitude(5 * u"°") == 10 * u"°" + Longitude(5 * u"°")


    for (AC, ut) in ((Longitude, u"°"), (Latitude, u"°"), (Depth, u"m"))
        @test AC(20 * ut) / 2 == 10 * ut
        @test AC(10 * ut) / 3 == (10 / 3) * ut
        @test (AC(10 * ut) / 3) / 2 == (10 / 3 / 2) * ut

        @test AC(10 * ut) + AC(10 * ut) + AC(10 * ut) == 3 * AC(10 * ut)
        @test AC(10 * ut) + AC(10 * ut) + AC(10 * ut) == AC(10 * ut) + (AC(10 * ut) + AC(10 * ut))
        @test AC(10 * ut) + AC(10 * ut) + AC(10 * ut) == (AC(10 * ut) + AC(10 * ut)) + AC(10 * ut)
        @test AC(10 * ut) * -1 + AC(10 * ut) == AC(10 * ut) - AC(10 * ut) == 0 * ut
        @test_throws MethodError AC / AC
        @test_throws MethodError AC * AC
    end

    @test Depth(10u"km") * -1 + 15u"km" != Depth(5u"km") # Depth(10u"km") * -1 cannot be Depth(-10u"km") (which is altitude).
    @test Depth(10u"km") * 1 + 15u"km" != Depth(25u"km")
    @test Depth(10u"km") + 15u"km" == 25u"km"
end
