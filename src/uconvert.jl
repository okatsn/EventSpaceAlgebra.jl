Unitful.uconvert(u, evt::EventTime) = EventTime(uconvert(u, evt.value))
Unitful.uconvert(u, evt::Longitude) = Longitude(uconvert(u, evt.value))
Unitful.uconvert(u, evt::Latitude) = Latitude(uconvert(u, evt.value))
Unitful.uconvert(u, evt::Depth) = Depth(uconvert(u, evt.value))
# Unitful.uconvert(u::Unitful.FreeUnits, evtc::Depth) = Depth(uconvert(u, evtc.value))

function uconvert!(uuuu::Tuple{U1,U2,U3,U4}, pt::XYZT) where {U1<:Unitful.FreeUnits} where {U2<:Unitful.FreeUnits} where {U3<:Unitful.FreeUnits} where {U4<:Unitful.FreeUnits}
    XYZT(
        uconvert(uuuu[1], pt.x),
        uconvert(uuuu[2], pt.y),
        uconvert(uuuu[3], pt.z),
        uconvert(uuuu[4], pt.t),
        pt.ref
    )
end
