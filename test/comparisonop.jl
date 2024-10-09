@testset "Basic comparison" begin
    @test (Longitude(3.14u"rad") < Longitude(180u"°"))
    @test !(Longitude(3.14u"rad") > Longitude(180u"°"))
    @test (Longitude(π * u"rad") <= Longitude(180u"°"))
    @test (Longitude(π * u"rad") >= Longitude(180u"°"))

    @test Depth(500.01u"km") < Depth(5001u"km")
    @test Depth(5000.1u"km") > Depth(5000u"km")
    @test Depth(500.0u"km") <= Depth(500u"km")
    @test Depth(500.0u"km") >= Depth(500u"km")

    @test EventTime(500.01u"jd") < EventTime(5001u"jd")
    @test EventTime(5000.1u"jd") > EventTime(5000u"jd")
    @test EventTime(500.0u"jd") <= EventTime(500u"jd")
    @test EventTime(500.0u"jd") >= EventTime(500u"jd")
end


@testset "Prohibit comparisons over different coordinates." begin
    # Longitude and Latitude shouldn't be equal.
    a = 0.5π * u"rad"
    @test_throws EventSpaceAlgebra.CoordinateMismatch Latitude(a) != Longitude(a)
    @test_throws EventSpaceAlgebra.CoordinateMismatch Latitude(a) == Longitude(a)
    @test_throws EventSpaceAlgebra.CoordinateMismatch Latitude(a) != Depth(5u"km")
    @test_throws EventSpaceAlgebra.CoordinateMismatch Latitude(a) == Depth(5u"km")
    @test_throws EventSpaceAlgebra.CoordinateMismatch Latitude(a) != EventTime(5.2u"jd")
    @test_throws EventSpaceAlgebra.CoordinateMismatch Latitude(a) == EventTime(5.2u"jd")
    # of different parameter should work
    @test EventTime(5u"jd") == EventTime(5.0u"jd")
    @test Depth(2930u"m") == Depth(2.930u"km")


    # You cannot compare Latitude with Longitude.
    @test_throws MethodError Latitude(a) < Longitude(a)
    @test_throws MethodError Latitude(a) > Longitude(a)
    @test_throws MethodError Latitude(a) <= Longitude(a)
    @test_throws MethodError Latitude(a) >= Longitude(a)
end


@testset "Comparison integrity" begin
    @test isapprox(EventTimeMS(5), EventTimeMS(5.0))
    @test isapprox(EventTimeMS(5), EventTimeMS(5.0000000000001))
    @test isapprox(EventTimeJD(1 // 4), EventTimeJD(0.25))
    @test isequal(EventTimeMS(5), EventTimeMS(5.0))
    @test isequal(EventTimeJD(1 // 4), EventTimeJD(0.25))

    # # The following tests should returns true.
    dt = DateTime(2021, 12, 21)
    @test isequal(EventTimeMS(dt), EventTimeJD(dt))
    @test isequal(EventTimeJD(dt), EventTimeMS(dt))
    # You can compare EventTime directly with DateTime.
    @test isequal(EventTimeMS(dt), dt)
    @test isequal(EventTimeJD(dt), dt)
    @test isequal(dt, EventTimeMS(dt))
    @test isequal(dt, EventTimeJD(dt))
    @test isapprox(EventTimeMS(dt), EventTimeJD(dt))
    @test isapprox(EventTimeJD(dt), EventTimeMS(dt))
    # There is no `isapprox(::DateTime, ::DateTime)`
    # @test isapprox(EventTimeMS(dt), dt)
    # @test isapprox(EventTimeJD(dt), dt)
    @test isapprox(EventTime(121.33u"jd") - 110.1u"d", EventTime(11.32u"jd"))
end
