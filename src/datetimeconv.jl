struct NoMethodYet <: Exception
    vu::ValueUnit
end

Base.showerror(io::IO, e::NoMethodYet) = print(io, "Converting `$(typeof(get_value(e.vu)))` with unit `$(get_unit(e.vu))` to `DateTime` is not yet supported. Write a `autodatetime` for this conversion.")

Dates.DateTime(evt::EventTime) = autodatetime(evt)

function autodatetime(evt)
    u = get_unit(evt)
    v = get_value(evt)
    autodatetime(v, u)
end


autodatetime(v::Number, u::Type{<:EpochTime}) = throw(NoMethodYet(ValueUnit(v, u)))

function autodatetime(v::Union{AbstractFloat,Int}, ::Type{JulianDay})
    julian2datetime(v)
end
