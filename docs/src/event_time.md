```@meta
CurrentModule = EventSpaceAlgebra
```
# Event Time

`EventTime` is a `Quantity` of `Unitful.FreeUnits` [^1] of time dimension `Unitful.𝐓`, and allows `Unitful.uconvert` between other time units.

## The units

`EventTime` is expected to be time stamp on a certain time coordinate, in order to distinguish the the time when an event was occurred.
Specific units for `EventTime` is defined, as follows:

```@docs; canonical=false
EventSpaceAlgebra.ms_epoch
EventSpaceAlgebra.jd
```

## Interfaces

where they should be used via the following interface:

```@autodocs; canonical=false
Modules = [EventSpaceAlgebra]
Pages   = ["abstractspace.jl"]
```

## The unit of `EventTime` matters

Although it is allowed to use a `Quantity` of arbitrary time unit to define an `EventTime`, this kind of usage could be non-sense, as shown in the following example: 

```@example a123
using EventSpaceAlgebra, Unitful

time_stamp = 5u"ms_epoch" # A `Quantity` of `5` of unit `ms_epoch`.
time_duration = uconvert(u"ms", time_stamp)

to_datetime(EventTime(time_stamp))
```


```@example a123
try #hide
to_datetime(EventTime(time_duration)) 
# Shows error because it is non-sense to convert
# time of arbitrary unit to a point in the temporal space.
catch err; showerror(stderr, err); end  #hide
```

[^1]: https://painterqubits.github.io/Unitful.jl/stable/newunits/#Unitful.@unit