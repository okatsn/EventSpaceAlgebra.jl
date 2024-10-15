@testset "spatialconv.jl" begin
    using Unitful, Dates
    # Spatial
    @test uconvert(u"m", Depth(5.0)) == Depth(5000.0u"m")
    @test Depth(5u"km") == Depth(5000u"m")
    @test Depth(5u"km") == Depth(5000u"m")

    # Comparison between conventional length should result in inequalness.
    @test Depth(5u"km") != 5000u"m"
    @test Depth(5u"km") != 5u"km"

    @test isapprox(Depth((1 // 3) * u"m"), Depth(0.333333333333u"m"))
    @test !isequal(Depth((1 // 3) * u"m"), Depth(0.333333333333u"m"))

    @test isapprox(Longitude(3.14159265359u"rad"), Longitude(180u"°"))
    @test isapprox(Latitude(3.14159265359u"rad"), Latitude(180u"°"))

    @test (Latitude(180u"°"), Longitude(18u"°")) == latlon(180, 18)

    # Temporal
    @test EventSpaceAlgebra.epochms0 == DateTime(0000, 1, 1)
    @test EventTimeMS(0.0) == uconvert(ms_epoch, EventTimeJD(EventSpaceAlgebra.epochms0))

    @test EventTimeJD(EventSpaceAlgebra.epochms0) == EventTimeMS(EventSpaceAlgebra.epochms0)
    @test EventTimeJD(EventSpaceAlgebra.julianday0) == EventTimeMS(EventSpaceAlgebra.julianday0)
    dt = DateTime(2024, 8, 10, 7, 12, 5)
    @test EventTimeJD(dt) == EventTimeMS(dt)
    @test EventTimeJD(dt).value.val != EventTimeMS(dt).value.val
    # although the units are different, they both indicate the same absolute time

    @test isequal(EventTimeJD(0), uconvert(jd, EventTime(-EventSpaceAlgebra.epoch_julian_diff_ms * u"ms_epoch")))

    # Test differentiation and compares vectors of event time.
    @test diff([EventTimeJD(i) for i in 1:10]) == [Millisecond(Day(1)) for _ in 1:9]

    evtpairs = [(EventTimeJD(dt + Day(i)), EventTimeMS(dt + Day(i))) for i in 1:10]
    @test first.(evtpairs) == last.(evtpairs)
    @test all(first.(evtpairs) .== last.(evtpairs))

    a = first.(evtpairs)
    b = last.(evtpairs) .+ Day(1)
    @test a != b
    @test all(a .!= b)
end
