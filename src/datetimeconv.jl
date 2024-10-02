function to_datetime(t::EventTimeMS)
    epoch = DateTime(0000, 1, 1)
    delta = Millisecond(uconvert(u"ms", t.value).val)
    epoch + delta
end

function to_datetime(t::EventTimeJD)
    Dates.julian2datetime(t.value.val)
end

Dates.DateTime(evt::EventTime) = to_datetime(evt)
