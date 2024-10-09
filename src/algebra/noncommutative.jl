# # Non-commutative operations

for op in (:-, :isless), AC in (:Latitude, :Longitude, :Depth, :EventTime)
    @eval function Base.$op(t1::$AC, t2::$AC)
        $op(t1.value, t2.value)
    end
end
