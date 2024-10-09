# # Non-commutative operations

for op in (:-, :isless), AC in (:Latitude, :Longitude, :Depth, :EventTime)
    @eval function Base.$op(t1::$AC, t2::$AC)
        $op(t1.value, t2.value)
    end
end


# # Subtract
function Base.:-(t1::EventTime{T,U}, t2::Quantity) where {T} where {U}
    EventTime{T,U}(t1.value - t2)
end

function Base.:-(t1::EventTime{T,U}, Δt::Dates.AbstractTime) where {T} where {U}
    EventTime{T,U}(t1.value - Quantity(Δt))
end
