@testset "datetimeconv.jl" begin
    using Dates
    dt = DateTime(2023, 1, 2)
    evt = EventTime(datetime2julian(dt), JulianDay)
    @test isequal(dt, DateTime(evt))
    @test_throws EventSpaceAlgebra.NoMethodYet EventSpaceAlgebra.autodatetime(3.3, EventSpaceAlgebra.DummyDayForTest)
end
