@testset "datetimeconv.jl" begin
    using Dates
    dt = DateTime(2023, 1, 2)
    # TODO: Test EventTime and its conversion function
    # evt = EventTime(datetime2julian(dt), JulianDay)
    # @test isequal(dt, DateTime(evt))
    absms = Dates.datetime2epochms(dt)
    d_epoch = Dates.datetime2julian(dt)
    evt1 = EventTime(absms * u"ms_epoch")
    evt2 = EventTime(d_epoch * u"jd")
    @test to_datetime(evt1) == dt
    @test to_datetime(evt2) == dt
end
