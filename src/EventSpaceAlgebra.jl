module EventSpaceAlgebra

abstract type CustomError <: Exception end

using Dates
using Unitful
include("unitfulunits.jl")
function __init__()
    Unitful.register(@__MODULE__)
end
export @u_str
export ms_epoch, jd, deg_N, deg_E, dep_km

include("abstractspace.jl")
export EventTime, EventTimeJD, EventTimeMS
export EventCoordinate

include("spatial.jl")
export Longitude, Latitude
export Depth

include("uconvert.jl")
export uconvert

include("timespacetypes.jl")
# include("algebra/sameunit.jl")
include("algebra/comparisonop.jl")
include("algebra/addsubtract.jl")

# export Longitude, Latitude, EventTime, JulianDay

using Dates
include("datetimeconv.jl")
export to_datetime


include("magnitudescales.jl")
export EventMagnitude, MomentMagnitude, SurfaceWaveMagnitude, RichterMagnitude, AbstractMagnitudeScale


include("eventpoint.jl")
export EventPoint, ArbitraryPoint, shift!

using Distances, Geodesy
include("distances.jl")
export haversine
export LLA, ECEF



# # Export error structures
export UnitIncompatible, UnitMismatch

end
