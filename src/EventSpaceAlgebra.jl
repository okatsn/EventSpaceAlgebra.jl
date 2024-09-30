module EventSpaceAlgebra

using Unitful

include("abstractspace.jl")
include("timespacetypes.jl")
# include("algebra/sameunit.jl")
include("algebra/comparisonop.jl")
include("algebra/addsubtract.jl")

export Longitude, Latitude, EventTime, JulianDay

using Dates
include("datetimeconv.jl")
end
