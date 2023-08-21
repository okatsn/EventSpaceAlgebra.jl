module EventSpaceAlgebra
include("abstractspace.jl")
include("timespacetypes.jl")
include("algebra/sameunit.jl")
include("algebra/comparisonop.jl")
include("algebra/addsubstract.jl")

export Longitude, Latitude, EventTime, Degree, JulianDay, AngularDistance, EpochDuration, ValueUnit, GeneralSpace, Distance

end
