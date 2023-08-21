function Base.:-(gs1::T, gs2::T) where {T<:Coordinate}
    sameunit(gs1, gs2)
    Distance(get_value(gs1) - get_value(gs2), get_unit(gs1)) # extend `-` makes `diff` works with `Coordinate`
end
# CHECKPOINT

Base.:+(gs1::Coordinate, gs2::Coordinate) = get_value(gs1) + get_value(gs2)
