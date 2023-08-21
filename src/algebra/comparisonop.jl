## CHECKPOINT: You don't need to define `isequal` when ValueUnit is immutable.
# - `==` and thus `isequal` depend on `hash`
# - `DataFrames.groupby` also depends on `hash`
# - `mutable struct`s are hashed by reference, thus `ValueUnit(1, Degree) == ValueUnit(1, Degree)` returns `false` for `mutable struct ValueUnit ...end`.
# - `groupby` also group different constructs of the same `mutable struct`s into different groups, even they hold exactly the same contents.
# - I failed to write a `hash` for my AbstractSpace, as below. However, problem solved when I change ValueUnit to `mutable struct`.
#
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
