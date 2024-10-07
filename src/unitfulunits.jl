# KEYNOTE: To dispatch on unit, please use e.g., typeof(ms_epoch). See `to_datetime`
const julianday0 = Dates.julian2datetime(0)
const epochms0 = Dates.epochms2datetime(0)

const epoch_julian_diff_ms = epochms0 - julianday0

# # Following the official step and define the absolute unit first:
# https://painterqubits.github.io/Unitful.jl/stable/temperature/
@unit ms_abs "ms_abs" AbsoluteMillisecond 1 * u"ms" false
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
@affineunit jd "jd" -epoch_julian_diff_ms.value * ms_abs
# FIXME: What about Day(-epoch_julian_diff_ms.value) * d_abs?
# @unit jd "jd" JulianDay 86400u"s" false  # 1 Julian day = 86400 seconds

# @affineunit d_epoch "d_epoch" Dates.datetime2julian(epochms0) * jd
# @affineunit ms_epoch "ms_epoch" Dates.datetime2julian(epochms0) * jd
