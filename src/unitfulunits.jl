# KEYNOTE: To dispatch on unit, please use e.g., typeof(ms_epoch). See `to_datetime`
const julianday0 = Dates.julian2datetime(0)
const epochms0 = Dates.epochms2datetime(0)

const epoch_julian_diff_ms = (epochms0 - julianday0).value
const epoch_julian_diff_d = floor(Millisecond(epoch_julian_diff_ms), Day).value + (julianday0 - floor(julianday0, Day)) / Millisecond(Day(1))

# # Following the official step and define the absolute unit first:
# https://painterqubits.github.io/Unitful.jl/stable/temperature/
"""
The time unit in unit `Unitful.ms` for `EventSpaceAlgebra.ms_epoch`'s reference.

```jldoctest
julia> using EventSpaceAlgebra

julia> 0u"ms" == 0u"ms_epoch"
true

julia> uconvert(u"ms", 0u"ms_epoch")
0 ms
```
"""
@unit ms_abs "ms_abs" AbsoluteMillisecond 1 * u"ms" false

"""
The time unit in unit `Unitful.d` for `EventSpaceAlgebra.jd`'s reference.
This makes the `0u"d"` mutually the same as `0u"jd"`.

```jldoctest
julia> using EventSpaceAlgebra

julia> uconvert(u"jd", 0u"d").val == EventSpaceAlgebra.epoch_julian_diff_d # which is about 1.7210595e6 jd
true
```
"""
@unit d_abs "d_abs" AbsoluteDay 1 * u"d" false

#
"""
Absolute time stamp unit in `Millisecond`.
To dispatch by this unit, please use e.g., `typeof(ms_epoch)`.

```jldoctest
using Unitful, EventSpaceAlgebra
Quantity(5, ms_epoch) == 5u"ms_epoch"

# output

true
```
"""
@affineunit ms_epoch "ms_epoch" 0 * ms_abs
# @unit jms_internal "jms_internal" JulianMillisecond 1u"ms" false
# @unit ms_epoch "ms_epoch" EpochMillisecond 1u"ms" false

"""
Absolute time stamp unit Julian Day (of each day fixed to the length 86400 seconds).
To dispatch by this unit, please use e.g., `typeof(jd)`.
"""
@affineunit jd "jd" -epoch_julian_diff_d * d_abs
# @unit jd "jd" JulianDay 86400u"s" false  # 1 Julian day = 86400 seconds

# @affineunit d_epoch "d_epoch" Dates.datetime2julian(epochms0) * jd
# @affineunit ms_epoch "ms_epoch" Dates.datetime2julian(epochms0) * jd


# # todo: °N, °S, °E, °W for Longitude/Latitude; see the following concerns:
# - This is not necessary, since currently +/- with struct Longitude/Latitude is complete.
# - You have to prohibit comparison between u"°" and u"°N", that is, for example, for `1u"°N" == 1u"°"` shouldn't return `true`.
# - Also prohibit `uconvert` between between u"°" and u"°N".
# - This may also involves normalization (e.g., Latitude of -10° => 10°S; 110° => 70°N)
# - This will involve redefinition in `EventAngleDegree{T}` and thus `Longitude{T}`

@unit deg_N "°N" DegreeNorth 1 * u"°" false
@unit deg_E "°E" DegreeEast 1 * u"°" false
@unit dep_km "dep_km" DepthKM 1 * u"km" false
