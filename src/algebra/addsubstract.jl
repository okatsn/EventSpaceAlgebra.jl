function Base.:-(gs1::T, gs2::T) where {T<:GeneralSpace}
    sameunit(gs1, gs2)
    Distance(get_value(gs1) - get_value(gs2), get_unit(gs1)) # extend `-` makes `diff` works with `GeneralSpace`
end
# CHECKPOINT

Base.:+(gs1::GeneralSpace, gs2::GeneralSpace) = get_value(gs1) + get_value(gs2)
