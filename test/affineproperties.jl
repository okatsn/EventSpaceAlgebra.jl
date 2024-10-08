@testset "affineproperties.jl" begin
    using Dates, Unitful
    @test 1u"ms" + 1u"ms" == 1u"ms" + 1u"ms_epoch"
    @test_throws Unitful.AffineError 1u"ms_epoch" + 1u"ms_epoch"
    @test 1u"d" + 1u"jd" == Day(1) + 1u"jd" == 2u"jd"
    @test_throws Unitful.AffineError 1u"jd" + 1u"jd"
    @test_throws Unitful.AffineError 1u"ms_epoch" + 1u"jd"
    @test 0.0u"ms" == 0.0u"ms_epoch"
    @test 0.0u"d" == EventSpaceAlgebra.epoch_julian_diff_d * u"jd"
end
