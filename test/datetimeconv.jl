@testset "datetimeconv.jl" begin
    using Dates
    dt = DateTime(2023, 1, 2)
    # TODO: Test EventTime and its conversion function
    # evt = EventTime(datetime2julian(dt), JulianDay)
    # @test isequal(dt, DateTime(evt))
    absms = Dates.datetime2epochms(dt)
    d_epoch = Dates.datetime2julian(dt)
    evt1 = EventTime(absms * u"ms_epoch")
    evt1a = EventTimeMS(absms)
    evt2 = EventTime(d_epoch * u"jd")
    evt2a = EventTimeJD(d_epoch)
    @test to_datetime(evt1) == to_datetime(evt1a) == dt
    @test to_datetime(evt2) == to_datetime(evt2a) == dt
    @test uconvert(u"jd", evt1a) == evt2a
    @test uconvert(u"ms_epoch", evt2a) == evt1a


    # Test whether `epoch_julian_diff_d` are calculated correctly (against `epochms0`)
    rounded_day = floor(EventSpaceAlgebra.epoch_julian_diff_d)
    inexact_day = EventSpaceAlgebra.epoch_julian_diff_d - rounded_day

    @test EventSpaceAlgebra.julianday0 + Day(rounded_day) + Hour(24 * inexact_day) == EventSpaceAlgebra.epochms0
    @test to_datetime(EventTimeMS(EventSpaceAlgebra.epochms0)) == to_datetime(EventTimeJD(EventSpaceAlgebra.epochms0))

end
