Unitful.uconvert(u::Unitful.FreeUnits, evtc::Depth) = Depth(uconvert(u, evtc.value))


Unitful.uconvert(::typeof(ms_epoch), evtc::TemporalCoordinate{T,U}) where {T} where {U} = EventTimeMS{T}(evtc)

function Unitful.uconvert(::typeof(jd), evtc::TemporalCoordinate{T,U}) where {T} where {U}
    EventTimeJD{T}(evtc)
    # print(T)
end
