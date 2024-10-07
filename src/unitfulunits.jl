# KEYNOTE: To dispatch on unit, please use e.g., typeof(ms_epoch). See `to_datetime`
const julianday0 = Dates.julian2datetime(0)
const epochms0 = Dates.epochms2datetime(0)

const epoch_julian_diff_ms = epochms0 - julianday0


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
@unit ms_epoch "ms_epoch" EpochMillisecond 1u"ms" false

"""
Absolute time stamp unit Julian Day (of each day fixed to the length 86400 seconds).
To dispatch by this unit, please use e.g., `typeof(jd)`.
"""
@unit jd "jd" JulianDay 86400u"s" false  # 1 Julian day = 86400 seconds
