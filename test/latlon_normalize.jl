@testset "latlon_normalize" begin
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

    @test latlon_normalize(Latitude(80 * u"°")) == latlon_normalize(Latitude(80 * u"°"))
    @test latlon_normalize(Latitude(-280 * u"°")) == latlon_normalize(Latitude(80 * u"°"))
    @test latlon_normalize(Latitude(100 * u"°")) == latlon_normalize(Latitude(80 * u"°"))
    @test latlon_normalize(Latitude(-170 * u"°")) == latlon_normalize(Latitude(-10 * u"°"))

end
