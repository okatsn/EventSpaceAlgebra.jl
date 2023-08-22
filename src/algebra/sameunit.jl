struct UnitMismatch <: Exception end
Base.showerror(io::IO, e::UnitMismatch) = print(io, "Unit mistach.")



"""
Check if two objects of `ValueUnit` has the same unit.
"""
function sameunit(gs1, gs2)
    _sametype(get_unit(gs1), get_unit(gs2))
end

_sametype(a::Type{T}, b::Type{T}) where {T<:GeneralUnit} = true
_sametype(a, b) = throw(UnitMismatch())
