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

    @test Latitude(-170 * u"°") / 17 == -10 / 17 * u"°"
    @test mean(v1) == mean(v2)
end
