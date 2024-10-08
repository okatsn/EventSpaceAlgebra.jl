@testset "affineproperties.jl" begin
    @test 1u"ms" + 1u"ms" == 1u"ms" + 1u"ms_epoch"
    @test_throws ERROR:AffineError 1u"ms_epoch" + 1u"ms_epoch"
    @test 1u"d" + 1u"d" == 1u"d" + 1u"jd"
    @test_throws ERROR:AffineError 1u"jd" + 1u"jd"
    @test_throws ERROR:AffineError 1u"ms_epoch" + 1u"jd"
    @test 0u"ms" == 0u"ms_epoch" == 0u"d" == -EventSpaceAlgebra.epoch_julian_diff_d * u"jd"
end
