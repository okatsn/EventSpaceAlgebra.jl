@testset "magnitude.jl" begin
    using Statistics
    @test_throws EventSpaceAlgebra.CoordinateMismatch EventMagnitude{MomentMagnitude}(5) == EventMagnitude{RichterMagnitude}(5)
    @test_throws EventSpaceAlgebra.CoordinateMismatch isapprox(EventMagnitude{MomentMagnitude}(5), EventMagnitude{RichterMagnitude}(5))
    @test EventMagnitude{RichterMagnitude}(5) + EventMagnitude{RichterMagnitude}(3) == 8
    @test EventMagnitude{RichterMagnitude}(5) - EventMagnitude{RichterMagnitude}(3) == 2
    # # FIXME: The following tests results in error. See magnitudescale.jl
    # @test EventMagnitude{RichterMagnitude}(5) - EventMagnitude{RichterMagnitude}(2) - EventMagnitude{RichterMagnitude}(1) + EventMagnitude{RichterMagnitude}(3) == 5
    # @test EventMagnitude{RichterMagnitude}(5) - EventMagnitude{RichterMagnitude}(2) - EventMagnitude{RichterMagnitude}(1) == 2
    @test EventMagnitude{RichterMagnitude}(5) * 2 == 10
    @test EventMagnitude{RichterMagnitude}(5) / 2 == 2.5
    @test EventMagnitude{RichterMagnitude}(5) + EventMagnitude{RichterMagnitude}(5) == 2 * EventMagnitude{RichterMagnitude}(5)
    @test EventMagnitude{RichterMagnitude}(5) + EventMagnitude{RichterMagnitude}(5) + EventMagnitude{RichterMagnitude}(5) == 3 * EventMagnitude{RichterMagnitude}(5)
    @test EventMagnitude{RichterMagnitude}(5) / 2 == EventMagnitude{RichterMagnitude}(5) * 0.5

    v = 1:10
    vmag = EventMagnitude{RichterMagnitude}.(v)
    @test mean(vmag) == sum(vmag) / length(vmag) == mean(v)
    @test std(vmag) == std(v)

end
