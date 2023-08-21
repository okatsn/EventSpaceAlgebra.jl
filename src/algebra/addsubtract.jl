"""
`Base.:-(gs1, gs2)` do subtraction of `gs1` and `gs2` of the `sameunit`.
"""
function Base.:-(gs1, gs2)
    throw(CoordinateMismatch())
end


function _same_unit_subtraction(gs1, gs2)
    sameunit(gs1, gs2)
    Distance(get_value(gs1) - get_value(gs2), get_unit(gs1))
end

"""
`Base.:-(gs1::T, gs2::T) where {T<:Coordinate}` returns a `Distance`.
`gs1` and `gs2` of the same `Coordinate` can be subtracted.
"""
function Base.:-(gs1::T, gs2::T) where {T<:Coordinate}
    _same_unit_subtraction(gs1, gs2)
end

"""
`Base.:-(gs1::Coordinate, gs2::Distance)` returns a `Distance`.
`gs1::Coordinate` can be subtracted by `gs2::Distance`.
"""
function Base.:-(gs1::Coordinate, gs2::Distance)
    _same_unit_subtraction(gs1, gs2)
end


"""
`Base.:-(gs1::Distance, gs2::Distance)` returns a `Distance`.
`gs1::Distance` can be subtracted by `gs2::Distance`.
"""
function Base.:-(gs1::Distance, gs2::Distance)
    _same_unit_subtraction(gs1, gs2)
end

Base.:+(gs1::Coordinate, gs2::Coordinate) = get_value(gs1) + get_value(gs2)
