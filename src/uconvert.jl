Unitful.uconvert(u::Unitful.FreeUnits, evtc::Depth) = Depth(uconvert(u, evtc.value))

"""
Convert `EventTimeJD` to `EventTimeMS`:

# Example

```jldoctest
julia> using Dates, EventSpaceAlgebra, Unitful

julia> dt = DateTime(-4713, 11, 24, 12, 00, 00) - DateTime(0000, 1, 1);

julia> evt2 = EventTimeJD(0);

julia> EventTimeMS{Int}(evt2) == EventTimeMS(dt.value) == uconvert(ms_epoch, evt2, Int)
true
```

"""
Unitful.uconvert(::typeof(ms_epoch), evtc::TemporalCoordinate, T::DataType) = EventTimeMS{T}(evtc)


"""
Convert `EventTimeMS` to `EventTimeJD`:

# Example

```jldoctest
julia> using Dates, EventSpaceAlgebra, Unitful

julia> evt1 = EventTimeMS(0);

julia> EventTimeJD{Float64}(evt1) == EventTimeJD(DateTime(0000, 1, 1)) == uconvert(jd, evt1, Float64)
true
```

"""
Unitful.uconvert(::typeof(jd), evtc::TemporalCoordinate, T::DataType) = EventTimeJD{T}(evtc)
