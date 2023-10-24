struct NoMethodYet <: Exception
    vu::ValueUnit
end

Base.showerror(io::IO, e::NoMethodYet) = print(io, "Converting `$(typeof(e.vu.v))` with unit `$(e.vu.u)` to `DateTime` is not yet supported. Write a `autodatetime` for this conversion.")

Dates.DateTime(evt::EventTime) = autodatetime(evt)

function autodatetime(evt)
    u = get_unit(evt)
    v = get_value(evt)
    autodatetime(v, u)
end


autodatetime(v::Number, u::Type{<:EpochTime}) = throw(NoMethodYet(ValueUnit(v, u)))

function autodatetime(v::AbstractFloat, ::Type{JulianDay})
    julian2datetime(v)
end
