# # Non-commutative operations

# # Comparison and Subtraction
for op in (:(==), :isapprox, :isless, :-), AC in (:Latitude, :Longitude, :Depth, :EventTime)
    @eval function Base.$op(t1::$AC, t2::$AC)
        $op(t1.value, t2.value)
    end
end


for op in (:+, :-), AC in (:Latitude, :Longitude, :Depth, :EventTime)
    @eval function Base.$op(t1::$AC, t2)
        $AC($op(t1.value, t2))
    end
end

# Commutative properties for some operations
for op in (:+,), AC in (:Latitude, :Longitude, :Depth, :EventTime)
    @eval function Base.$op(t1, t2::$AC)
        $op(t2.value, t1)
    end
end


# # Special cases
function Base.:+(t1::EventTime, Δt::Dates.AbstractTime)
    typeof(t1)(t1.value + Quantity(Δt))
end

# Ensure the commutative property:
Base.:+(Δt::Dates.AbstractTime, t1::EventTime) = t1 + Δt
