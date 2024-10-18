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

    apt1 = ArbitraryPoint(EventTimeMS(0.0), taipei101..., Depth(0u"km"))
    ref1 = ArbitraryPoint(EventTimeJD(0.0), daan..., Depth(0u"km"))
    enu1 = ENU(apt1, ref1)

    xyz1 = XYZ(apt1, ref1)
    @test enu1.e == xyz1.x.val
    @test enu1.n == xyz1.y.val
    @test enu1.u == xyz1.z.val
    @test xyz1.ref.lat == ref1.lat
    @test xyz1.ref.lon == ref1.lon
    @test xyz1.ref.depth == ref1.depth

    xyzt1 = XYZT(apt1, ref1)
    x0 = xyzt1.x.val # in meters
    y0 = xyzt1.y.val # in meters
    z0 = xyzt1.z.val # in meters
    t0 = uconvert(u"s", xyzt1.t).val # ensures to be seconds

    @test x0 == xyz1.x.val
    @test y0 == xyz1.y.val
    @test z0 == xyz1.z.val

    @test enu1.e == xyzt1.x.val
    @test enu1.n == xyzt1.y.val
    @test enu1.u == xyzt1.z.val
    @test xyzt1.ref.lat == ref1.lat
    @test xyzt1.ref.lon == ref1.lon
    @test xyzt1.ref.depth == ref1.depth
    @test xyzt1.ref.time == ref1.time
    @test ref1.time + xyzt1.t == apt1.time

    @testset "uconvert!" begin
        uuuu = (u"km", u"cm", u"km", u"hr")
        uuu = (u"km", u"cm", u"km")
        uconvert!(uuuu, xyzt1)
        uconvert!(uuu, xyz1)
        @test 0.001 * x0 == xyz1.x.val == xyzt1.x.val
        @test 100 * y0 == xyz1.y.val == xyzt1.y.val
        @test 0.1 * z0 == xyz1.z.val == xyzt1.z.val

        uconvert!(u"cm", u"hr", xyzt1)
        @test_throws MethodError uconvert!(u"cm", u"hr", xyz1)
        uconvert!(u"cm", xyz1)

        @test 100 * x0 == xyz1.x.val == xyzt1.x.val
        @test 100 * y0 == xyz1.y.val == xyzt1.y.val
        @test 100 * z0 == xyz1.z.val == xyzt1.z.val
        @test 1 / 3600 * t0 == xyzt1.t.val



    end

    @test isapprox(haversine(taipei101, daan), norm(enu1, 2), atol=10) # Haversine v.s. ENU distance with error below 10 meters
    @test isapprox(norm(enu1, 2), 1948.8, atol=1) # google earth's distance
    @test isapprox(norm(ENU(ArbitraryPoint(taipei101..., Depth(0u"m")), ArbitraryPoint(taipei101..., Depth(-508u"m")))), 508)

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


    @test isapprox(
        norm(ENU(ArbitraryPoint(latlon(34.0, -118.0)..., Depth(0)),
            ArbitraryPoint(latlon(34.1800, -118.0)..., Depth(0)))),
        20000, # approximately 20 km (ChatGPT's answer)
        atol=1000)

    # # Test Points Near the Poles and Equator
    # Answer from: # https://www.thoughtco.com/degree-of-latitude-and-longitude-distance-4070616

    # What Is the Distance Between Degrees of Latitude?
    @test isapprox(
        norm(ENU(ArbitraryPoint(latlon(0.5, 0.0)..., Depth(0)),
                ArbitraryPoint(latlon(-0.5, 0.0)..., Depth(0))), 2),
        110_567,
        atol=10) # error: ≤ 10 meters

    @test isapprox(
        norm(ENU(ArbitraryPoint(latlon(90, 0.0)..., Depth(0)),
                ArbitraryPoint(latlon(89, 0.0)..., Depth(0))), 2),
        111_699,
        atol=10) # error: ≤ 10 meters

    # What Is the Distance Between Degrees of Longitude?
    @test isapprox(
        norm(ENU(ArbitraryPoint(latlon(0.0, 0.0)..., Depth(0)),
                ArbitraryPoint(latlon(0.0, 1.0)..., Depth(0))), 2),
        111_321,
        atol=10) # error: ≤ 10 meters

    @test isapprox(
        norm(ENU(ArbitraryPoint(latlon(40.0, 0.0)..., Depth(0)),
                ArbitraryPoint(latlon(40.0, 1.0)..., Depth(0))), 2),
        85_000,
        atol=500) # error: ≤ 10 meters

end
