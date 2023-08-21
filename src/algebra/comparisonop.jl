function Base.:(==)(as1::AbstractSpace, as2::AbstractSpace)
    isequal(get_unit(as1), get_unit(as2)) && isequal(get_value(as1), get_value(as2))
end


function Base.isapprox(as1::AbstractSpace, as2::AbstractSpace)
    isequal(get_unit(as1), get_unit(as2)) && isapprox(get_value(as1), get_value(as2))
end


function Base.isless(gs1::T, gs2::T) where {T<:AbstractSpace}
    sameunit(gs1, gs2)
    isless(get_value(gs1), get_value(gs2)) # This makes `extrema`, `maximum` and `minimum` works with `Coordinate`.
end
