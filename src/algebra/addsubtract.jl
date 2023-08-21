struct CoordinateMismatch <: Exception end
Base.showerror(io::IO, e::CoordinateMismatch) = print(io, "Coordinate mistach.")

"""
`Base.:-(gs1, gs2)` do subtraction of `gs1` and `gs2` of the `sameunit`.
It throws `CoordinateMismatch` error despite the following cases:
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

"""
`_create_add(gs1, gs2)` do `sameunit` check for `gs1` and `gs2`,
performs addition of their `value`, and return a copy of `gs1` with the `value` of `gs1` the sum of `value` of the input arguments.
"""
function _create_add(gs1, gs2)
    sameunit(gs1, gs2)
    newval = get_value(gs1) + get_value(gs2)
    gs1a = deepcopy(gs1)
    set_value!(gs1a, newval)
    return gs1a
end

"""
`Base.:+(gs1::Coordinate, gs2::Distance)` returns a copy of `Coordinate` of the same type as `gs1`, with its `value` being the sum of the values of `gs1` and `gs2`.
"""
Base.:+(gs1::Coordinate, gs2::Distance) = _create_add(gs1, gs2)

"""
Addition is commutative.
Thus, `+(gs2::Distance, gs1::Coordinate)` falls back to `+(gs1, gs2)`.
"""
Base.:+(gs2::Distance, gs1::Coordinate) = +(gs1, gs2)


"""
`+(gs1::T, gs2::T) where {T<:Distance}`
performs the addition of the two `Distance` of the same type. It returns `Distance` of the same unit, with the value of their sum.
"""
Base.:+(gs1::T, gs2::T) where {T<:Distance} = _create_add(gs1, gs2)

"""
Otherwise, throws error `CoordinateMismatch`.
"""
Base.:+(gs1, gs2) = throw(CoordinateMismatch())
