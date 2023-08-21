module EventSpaceAlgebra
include("abstractspace.jl")
include("timespacetypes.jl")
include("algebra/sameunit.jl")
include("algebra/comparisonop.jl")
include("algebra/addsubtract.jl")

export Longitude, Latitude, EventTime, Degree, JulianDay, AngularDistance, EpochDuration, ValueUnit

# General interface for construction
export Coordinate, Distance

end
