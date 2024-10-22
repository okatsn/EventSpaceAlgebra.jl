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

function Base.:+(a::EventMagnitude{T}, b::EventMagnitude{T}) where {T}
    +(a.value, b.value)
end

function Base.:-(a::EventMagnitude{T}, b::EventMagnitude{T}) where {T}
    -(a.value, b.value)
end

function Base.:-(a::EventMagnitude, b::Real)
    -(a.value, b)
end # FIXME: This allows `std` to work with `EventMagnitude`; however, it is strange and non-sense to subtract/add EventMagnitude by `Real` number. One solution is to define extra units for `MagnitudeScale`.
# FIXME: The following definition for `+` between EventMagnitude and Real has the same problem.


for op in (:+, :*)
    @eval function Base.$op(a::EventMagnitude, b::Real)
        $op(a.value, b)
    end

    @eval Base.$op(a::Real, b::EventMagnitude) = $op(b, a)

end

function Base.:/(a::EventMagnitude, b::Real)
    /(a.value, b)
end

for op in (:(==), :isapprox, :isless)
    @eval function Base.$op(a::EventMagnitude{T}, b::EventMagnitude{T}) where {T}
        $op(a.value, b.value)
    end
end

for op in (:(==), :isapprox, :isless)
    @eval function Base.$op(t1::EventMagnitude{A}, t2::EventMagnitude{B}) where {A,B}
        throw(CoordinateMismatch())
    end
end


function Base.:(==)(a::EventMagnitude, b::Real)
    throw(CoordinateMismatch())
end

Base.:(==)(a::Real, b::EventMagnitude) = ==(b, a)
