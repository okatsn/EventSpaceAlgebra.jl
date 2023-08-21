## CHECKPOINT: You don't need to define `isequal` when ValueUnit is immutable.
# function Base.hash(as1::AbstractSpace)
#     h1 = hash(get_value(as1))
#     hash(get_unit(as1), h1)
# end

# function Base.:(==)(as1::AbstractSpace, as2::AbstractSpace)
#     isequal(get_unit(as1), get_unit(as2)) && isequal(get_value(as1), get_value(as2))
# end

# `isapprox` is required, since the unit should be exactly the same && value is approximately the same
function Base.isapprox(as1::AbstractSpace, as2::AbstractSpace)
    isequal(get_unit(as1), get_unit(as2)) && isapprox(get_value(as1), get_value(as2))
end

# This makes `extrema`, `maximum` and `minimum` works with `Coordinate`.
function Base.isless(gs1::T, gs2::T) where {T<:AbstractSpace}
    sameunit(gs1, gs2)
    isless(get_value(gs1), get_value(gs2))
end
