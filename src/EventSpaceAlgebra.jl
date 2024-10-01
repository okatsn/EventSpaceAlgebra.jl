module EventSpaceAlgebra

using Unitful
include("unitfulunits.jl")
function __init__()
    Unitful.register(@__MODULE__)
end
export ms_epoch, jd
include("abstractspace.jl")
export EventTime


include("timespacetypes.jl")
# include("algebra/sameunit.jl")
include("algebra/comparisonop.jl")
include("algebra/addsubtract.jl")

# export Longitude, Latitude, EventTime, JulianDay

using Dates
include("datetimeconv.jl")
export to_datetime
end
