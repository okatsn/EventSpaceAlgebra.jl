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
export Longitude, Latitude, latlon
export Depth

# Division and Multiplication operators
include("divmultiple.jl")


include("uconvert.jl")
export uconvert

include("timespacetypes.jl")
# include("algebra/sameunit.jl")
include("algebra/comparisonop.jl")
include("algebra/addsubtract.jl")

using Statistics
include("latlon_normalize.jl")
export latlon_normalize
# export Longitude, Latitude, EventTime, JulianDay



using Dates
include("datetimeconv.jl")
export to_datetime


include("magnitudescales.jl")
export EventMagnitude, MomentMagnitude, SurfaceWaveMagnitude, RichterMagnitude, MagnitudeScale
export AnySizeScale, EventPointSize

include("eventpoint.jl")
export EventPoint, ArbitraryPoint, shift!

using Distances, Geodesy
include("distances.jl")
export EARTH_RADIUS
export haversine
export LLA, ECEF, ENU



# # Export error structures
export UnitIncompatible, UnitMismatch

end
