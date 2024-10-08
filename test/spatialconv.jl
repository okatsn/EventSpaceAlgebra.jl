@testset "spatialconv.jl" begin
    using Unitful, Dates
    @test uconvert(u"m", Depth(5.0)) == Depth(5000.0u"m")
    @test EventSpaceAlgebra.epochms0 == DateTime(0000, 1, 1)
    @test EventTimeMS(0.0) == uconvert(ms_epoch, EventTimeJD(EventSpaceAlgebra.epochms0))

    @test EventTimeJD(EventSpaceAlgebra.epochms0) == EventTimeMS(EventSpaceAlgebra.epochms0)
    @test EventTimeJD(EventSpaceAlgebra.julianday0) == EventTimeMS(EventSpaceAlgebra.julianday0)
    dt = DateTime(2024, 8, 10, 7, 12, 5)
    @test EventTimeJD(dt) == EventTimeMS(dt)
    @test EventTimeJD(dt).value.val != EventTimeMS(dt).value.val
    # although the units are different, they both indicate the same absolute time

    @test isequal(EventTimeJD(0), uconvert(jd, EventTime(-EventSpaceAlgebra.epoch_julian_diff_ms * u"ms_epoch")))
end
