abstract type AbstractMagnitudeScale end

struct MomentMagnitude <: AbstractMagnitudeScale end   # Mw
struct RichterMagnitude <: AbstractMagnitudeScale end  # ML
struct SurfaceWaveMagnitude <: AbstractMagnitudeScale end  # MS

struct EventMagnitude{M<:AbstractMagnitudeScale}
    value::Float64
end
