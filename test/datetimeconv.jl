@testset "datetimeconv.jl" begin
    using Dates
    dt = DateTime(2023, 1, 2)
    # TODO: Test EventTime and its conversion function
    # evt = EventTime(datetime2julian(dt), JulianDay)
    # @test isequal(dt, DateTime(evt))
    absms = Dates.datetime2epochms(dt)
    d_epoch = Dates.datetime2julian(dt)
    evt = EventTime(absms * u"ms_epoch")
    @test to_datetime(evt) == dt
end
