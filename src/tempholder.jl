struct TemporaryHolder3{T<:EventCoordinate}
    value
end

for AC in (:Latitude, :Longitude, :Depth, :EventTime)
    @eval begin

        wrapper_type(::$AC) = $AC
    end
end

# # Operations between the value (i.e., `Quantity`) of `EventCoordinate` and `Real` numbers.
function Base.:/(a::EventCoordinate, b::Real)
    TemporaryHolder3{wrapper_type(a)}(/(a.value, b))
end

for AC in (:Latitude, :Longitude, :Depth)
    @eval function Base.:+(a::$AC, b::$AC)
        TemporaryHolder3{wrapper_type(a)}(+(a.value, b.value))
    end
end
