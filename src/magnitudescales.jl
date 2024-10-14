abstract type AnySizeScale end
abstract type MagnitudeScale <: AnySizeScale end

struct MomentMagnitude <: MagnitudeScale end   # Mw
struct RichterMagnitude <: MagnitudeScale end  # ML
struct SurfaceWaveMagnitude <: MagnitudeScale end  # MS

abstract type EventPointSize end

struct EventMagnitude{M<:MagnitudeScale} <: EventPointSize
    value::Float64
end

struct ArbitraryPointSize{M<:AnySizeScale} <: EventPointSize
    value::Float64
end
