function to_datetime(t::EventTime{T,typeof(ms_epoch)}) where {T}
    epoch = DateTime(0000, 1, 1)
    delta = Millisecond(uconvert(u"ms", t.value).val)
    epoch + delta
end

function to_datetime(t::EventTime{T,typeof(jd)}) where {T}
    Dates.julian2datetime(t.value.val)
end
Dates.DateTime(evt::EventTime) = to_datetime(evt)

# TODO: create `to_datetime` function.
