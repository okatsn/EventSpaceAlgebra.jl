function to_datetime(t::EventTime{EpochMillisecond})
    epoch = DateTime(1970, 1, 1)
    delta = Millisecond(uconvert(u"ms", t.value).val)
    epoch + delta
end

function to_datetime(t::EventTime{JulianDay})
    Dates.julian2datetime(t.value.val)
end
Dates.DateTime(evt::EventTime) = to_datetime(evt)

# TODO: create `to_datetime` function.
