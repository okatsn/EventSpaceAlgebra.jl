@testset "distances.jl" begin
    # Example: https://medium.com/@manishkp220/haversine-formula-find-distance-between-two-points-2561d66c2d79
    wagle_estate = (Latitude(19.189354u"°"), Longitude(-72.951225u"°"))
    swami_vivekananda = (Latitude(19.186333u"°"), Longitude(-72.966961u"°"))
    kaohsiung = (Latitude(22.625109u"°"), Longitude(120.308952u"°"))
    taipei = (Latitude(25.091076u"°"), Longitude(121.559837u"°"))
    london = (Latitude(51.468434035839046u"°"), Longitude(-0.45611622730667717u"°"))
    sydney = (Latitude(-33.93375129186233u"°"), Longitude(151.17818184069466u"°"))

    # # Test for examples
    @test isapprox(haversine(swami_vivekananda, wagle_estate), 1.6863533312765095u"km")
    @test isapprox(haversine(taipei, kaohsiung), 302.26604153u"km")
    @test isapprox(haversine(london, sydney), 17019.4532353u"km")

    # # Test reversed input order
    @test isapprox(haversine(reverse(swami_vivekananda), reverse(wagle_estate)), 1.6863533312765095u"km")
    @test isapprox(haversine(reverse(taipei), reverse(kaohsiung)), 302.26604153u"km")
    @test isapprox(haversine(reverse(london), reverse(sydney)), 17019.4532353u"km")



    # # Comparison between haversine_distance
    location_pairs = [((Latitude(rand(-90:90) * u"°"), Longitude(rand(-180:180) * u"°")), (Latitude(rand(-90:90) * u"°"), Longitude(rand(-180:180) * u"°"))) for i = 1:20]
    for (l1, l2) in location_pairs
        @test isapprox(haversine(l1, l2), EventSpaceAlgebra.haversine_distance(l1, l2))
    end

end

@testset "Geodesic extensions" begin
    using Geodesy
    args0 = (Latitude(-27.468937u"°"), Longitude(153.023628u"°"), Depth(-0.0))
    lla0 = LLA(-27.468937, 153.023628, 0.0)

    args1 = (Latitude(-27.468937u"°"), Longitude(153.023628u"°"), Depth(1.0u"km"))
    lla1 = LLA(-27.468937, 153.023628, -1000.0)

    pt0 = ArbitraryPoint(args0...)
    pt1 = ArbitraryPoint(args1...)


    @test LLA(args1...) == LLA(pt1) == lla1
    @test ECEF(args0...) == ECEF(pt0) == ECEF(lla0, wgs84)

    @test ENU(lla0, lla1, wgs84) == ENU(pt0, pt1)
    @test isapprox(ENU(pt0, pt1), ENU(0, 0, 1000))



end
