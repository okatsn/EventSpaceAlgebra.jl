@testset "distances.jl" begin
    # Example: https://medium.com/@manishkp220/haversine-formula-find-distance-between-two-points-2561d66c2d79
    wagle_estate = (Latitude(19.189354u"°"), Longitude(-72.951225u"°"))
    swami_vivekananda = (Latitude(19.186333u"°"), Longitude(-72.966961u"°"))
    kaohsiung = (Latitude(22.625109u"°"), Longitude(120.308952u"°"))
    taipei = (Latitude(25.091076u"°"), Longitude(121.559837u"°"))
    london = (Latitude(51.468434035839046u"°"), Longitude(-0.45611622730667717u"°"))
    sydney = (Latitude(-33.93375129186233u"°"), Longitude(151.17818184069466u"°"))

    # # Test for examples
    @test isapprox(haversine(swami_vivekananda, wagle_estate) * u"m", 1.6863533312765095u"km")
    @test isapprox(haversine(taipei, kaohsiung) * u"m", 302.26604153u"km")
    @test isapprox(haversine(london, sydney) * u"m", 17019.4532353u"km")

    # # Test reversed input order
    @test isapprox(haversine(reverse(swami_vivekananda), reverse(wagle_estate)) * u"m", 1.6863533312765095u"km")
    @test isapprox(haversine(reverse(taipei), reverse(kaohsiung)) * u"m", 302.26604153u"km")
    @test isapprox(haversine(reverse(london), reverse(sydney)) * u"m", 17019.4532353u"km")


    # #
    @test haversine(taipei, kaohsiung) == haversine(kaohsiung, taipei)
    @test haversine(taipei, kaohsiung, 6370_000) == haversine(kaohsiung, taipei, 6370_000)

    # # Comparison between haversine_distance
    location_pairs = [((Latitude(rand(-90:90) * u"°"), Longitude(rand(-180:180) * u"°")), (Latitude(rand(-90:90) * u"°"), Longitude(rand(-180:180) * u"°"))) for i = 1:20]
    for (l1, l2) in location_pairs
        @test isapprox(haversine(l1, l2) * u"m", EventSpaceAlgebra.haversine_distance(l1, l2))
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


@testset "Distance ENU v.s. Haversine" begin
    using LinearAlgebra
    kaohsiung = (Latitude(22.625109u"°"), Longitude(120.308952u"°"))
    taipei = (Latitude(25.091076u"°"), Longitude(121.559837u"°"))
    pt1 = ArbitraryPoint(kaohsiung..., Depth(0u"km"))
    pt2 = ArbitraryPoint(taipei..., Depth(0u"km"))
    @test haversine(taipei, kaohsiung) == haversine(pt1, pt2) == haversine(pt2, pt1)
    enu0 = ENU(pt1, pt2)
    @test abs(
        haversine(pt2, pt1) -
        sqrt(sum(enu0 .^ 2))
    ) ≤ 2000 # error below 2000 meters

    @test sqrt(sum(enu0 .^ 2)) == norm(enu0, 2)

    taipei101 = latlon(25.033044612802325, 121.56273533595018)
    the_other_side = latlon(-25.033045, -58.437265)

    daan = latlon(25.033287104794507, 121.54342755567457)

    enu1 = ENU(ArbitraryPoint(taipei101..., Depth(0u"km")), ArbitraryPoint(daan..., Depth(0u"km")))

    @test isapprox(haversine(taipei101, daan), norm(enu1, 2), atol=10) # Haversine v.s. ENU distance with error below 10 meters
    @test isapprox(norm(enu1, 2), 1948.8, atol=1) # google earth's distance


    half_perimeter = haversine(ArbitraryPoint(taipei101..., Depth(0u"km")), ArbitraryPoint(the_other_side..., Depth(0u"km")))
    @test isapprox(half_perimeter, EARTH_RADIUS.val * π, atol=1)


    @test isapprox(
        norm(
            ENU(
                ArbitraryPoint(latlon(34.000000, -118.000000)..., Depth(10)),
                ArbitraryPoint(latlon(34.000100, -118.000100)..., Depth(10)
                )
            ),
        ), 14.2, # ChatGPT's answer.
        atol=0.3)

    # Test Zero Distance
    @test isapprox(norm(ENU(ArbitraryPoint(latlon(34.000000, -118.000000)..., Depth(10)), ArbitraryPoint(latlon(34.000000, -118.000000)..., Depth(10)))), 0.0)
end
