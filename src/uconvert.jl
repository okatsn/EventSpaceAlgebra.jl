Unitful.uconvert(u, evt::EventTime) = EventTime(uconvert(u, evt.value))
Unitful.uconvert(u, evt::Longitude) = Longitude(uconvert(u, evt.value))
Unitful.uconvert(u, evt::Latitude) = Latitude(uconvert(u, evt.value))
Unitful.uconvert(u, evt::Depth) = Depth(uconvert(u, evt.value))
# Unitful.uconvert(u::Unitful.FreeUnits, evtc::Depth) = Depth(uconvert(u, evtc.value))

UnitfulUnitLength{N,A} = Unitful.FreeUnits{N,Unitful.𝐋,A}
UnitfulUnitTime{N,A} = Unitful.FreeUnits{N,Unitful.𝐓,A}

function uconvert!(uuuu::Tuple{
        UnitfulUnitLength,
        UnitfulUnitLength,
        UnitfulUnitLength,
        UnitfulUnitTime
    }, pt::XYZT)
    pt.x = uconvert(uuuu[1], pt.x)
    pt.y = uconvert(uuuu[2], pt.y)
    pt.z = uconvert(uuuu[3], pt.z)
    pt.t = uconvert(uuuu[4], pt.t)
    nothing
end

function uconvert!(uuu::Tuple{
        UnitfulUnitLength,
        UnitfulUnitLength,
        UnitfulUnitLength,
    }, pt::XYZ)
    pt.x = uconvert(uuu[1], pt.x)
    pt.y = uconvert(uuu[2], pt.y)
    pt.z = uconvert(uuu[3], pt.z)
    nothing
end


function uconvert!(uxyz::UnitfulUnitLength, ut::UnitfulUnitTime, pt::XYZT)
    pt.x = uconvert(uxyz, pt.x)
    pt.y = uconvert(uxyz, pt.y)
    pt.z = uconvert(uxyz, pt.z)
    pt.t = uconvert(ut, pt.t)
    nothing
end

function uconvert!(uxyz::UnitfulUnitLength, pt::AbstractCartesianPoint)
    pt.x = uconvert(uxyz, pt.x)
    pt.y = uconvert(uxyz, pt.y)
    pt.z = uconvert(uxyz, pt.z)
    nothing
end


function uconvert!(ut::UnitfulUnitTime, pt::XYZT)
    pt.t = uconvert(ut, pt.t)
    nothing
end
