@testset "spatialconv.jl" begin
    using Unitful
    @test uconvert(u"m", Depth(5.0)) == Depth(5000.0u"m")
    @test EventSpaceAlgebra.epochms0 == DateTime(0000, 1, 1)
    @test EventTimeMS(0.0) == uconvert(ms_epoch, EventTimeJD(epochms0), Float64)
    @test EventTimeJD(0) == uconvert(jd, EventTime(-EventSpaceAlgebra.epoch_julian_diff_ms.value * u"ms_epoch"), Int64)
end
