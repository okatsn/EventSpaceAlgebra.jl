module EventSpaceAlgebra

using Dates
using Unitful
include("unitfulunits.jl")
function __init__()
    Unitful.register(@__MODULE__)
end
export @u_str
export ms_epoch, jd

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
end
