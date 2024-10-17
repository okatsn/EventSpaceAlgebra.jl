for AC in (:Latitude, :Longitude, :Depth, :EventTime)
    @eval begin
        wrapper_type(::$AC) = $AC
    end
end

# # Operations between the value (i.e., `Quantity`) of `EventCoordinate` and `Real` numbers.
function Base.:/(a::EventCoordinate, b::Real)
    /(a.value, b) # follows the rule of `*`
end



"""
Operation with `*` in fact makes the quantity of length to live on another dimension; for example, `20u"m"*π` is the half perimeter of the circle of `20u"m"`, which does not live in the same dimension as the radius, though their units are the same.

Twice the depth of 10 km equals 20 km, but this result has no more meaning than "20 km" (e.g., you cannot say that it means "the depth of 20 km") until new connotations were imposed onto it in the external context.

# Example

```jldoctest
julia> Depth(5u"km") * 1 == 5u"km"
true

julia> Depth(1u"km") * (-1) == -1u"km" != Depth(-1u"km")
true

julia> 3u"m"*π == Depth(3u"m") * π
true

julia> Depth(5u"km") * 2 == 10u"km" == Depth(5u"km") + Depth(5u"km")
true
```
"""
function Base.:*(a::EventCoordinate, b::Real)
    *(a.value, b)
end

# # Commutative property for `+`

Base.:*(a::Real, b::EventCoordinate) = b * a
