abstract type AnySizeScale end
abstract type AbstractMagnitudeScale <: AnySizeScale end

struct MomentMagnitude <: AbstractMagnitudeScale end   # Mw
struct RichterMagnitude <: AbstractMagnitudeScale end  # ML
struct SurfaceWaveMagnitude <: AbstractMagnitudeScale end  # MS

abstract type EventPointSize end

struct EventMagnitude{M<:AbstractMagnitudeScale} <: EventPointSize
    value::Float64
end

struct ArbitraryPointSize{M<:AnySizeScale} <: EventPointSize
    value::Float64
end
