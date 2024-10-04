Unitful.uconvert(u::Unitful.FreeUnits, evtc::Depth) = Depth(uconvert(u, evtc.value))


Unitful.uconvert(::typeof(ms_epoch), evtc::TemporalCoordinate, T::DataType) = EventTimeMS{T}(evtc)

Unitful.uconvert(::typeof(jd), evtc::TemporalCoordinate, T::DataType) = EventTimeJD{T}(evtc)
