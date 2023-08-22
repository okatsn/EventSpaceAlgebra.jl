var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = EventSpaceAlgebra","category":"page"},{"location":"#EventSpaceAlgebra","page":"Home","title":"EventSpaceAlgebra","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for EventSpaceAlgebra.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [EventSpaceAlgebra]","category":"page"},{"location":"#EventSpaceAlgebra.Coordinate","page":"Home","title":"EventSpaceAlgebra.Coordinate","text":"Abstract type Coordinate are the supertype for all dimension/coordinate specification concrete structs of ValueUnit, such as Longitude, Latitude and EventTime.\n\n\n\n\n\n","category":"type"},{"location":"#EventSpaceAlgebra.Coordinate-Tuple{Type{<:Coordinate}, Any, Any}","page":"Home","title":"EventSpaceAlgebra.Coordinate","text":"The interface for constructing any concrete type belongs to Coordinate.\n\nExample\n\nLongitude(ValueUnit(1, Degree)) == Coordinate(Longitude, 1, Degree)\n\n# output\n\ntrue\n\n\n\n\n\n","category":"method"},{"location":"#EventSpaceAlgebra.Distance","page":"Home","title":"EventSpaceAlgebra.Distance","text":"Distance is the supertype for all types of \"distance\" on \"Coordinate\".\n\nDistance derived from multiple dimensional is beyond the scope of Distance.\nEach concrete struct of GeneralUnit corresponds to the only concrete struct of Distance\n\n\n\n\n\n","category":"type"},{"location":"#EventSpaceAlgebra.Distance-Tuple{Any, Any}","page":"Home","title":"EventSpaceAlgebra.Distance","text":"Distance(value, unit) construct a concrete struct of Distance.\n\nExample\n\nDistance(5, Degree) == AngularDistance(ValueUnit(5, Degree))\n\n# output\n\ntrue\n\n\n\nAdd a new type <: Distance\n\n\"Constructor\" Distance relies on disttype. Following the following steps to add new utilities:\n\nstruct NewDistance <: Distance\n    vu::ValueUnit\nend\nstruct NewDistUnit <: GeneralUnitOrOneOfItsAbstractType end\ndisttype(::Type{<:GeneralUnitOrOneOfItsAbstractType}) = NewDistance\n\nSee also: disttype.\n\n\n\n\n\n","category":"method"},{"location":"#EventSpaceAlgebra.ValueUnit","page":"Home","title":"EventSpaceAlgebra.ValueUnit","text":"ValueUnit is a simple mutable concrete structure that holds a value and the unit::GeneralUnit of the value.\n\n\n\n\n\n","category":"type"},{"location":"#Base.:+-Tuple{Any, Any}","page":"Home","title":"Base.:+","text":"Otherwise, throws error CoordinateMismatch.\n\n\n\n\n\n","category":"method"},{"location":"#Base.:+-Tuple{Coordinate, Distance}","page":"Home","title":"Base.:+","text":"Base.:+(gs1::Coordinate, gs2::Distance) returns a copy of Coordinate of the same type as gs1, with its value being the sum of the values of gs1 and gs2.\n\n\n\n\n\n","category":"method"},{"location":"#Base.:+-Tuple{Distance, Coordinate}","page":"Home","title":"Base.:+","text":"Addition is commutative. Thus, +(gs2::Distance, gs1::Coordinate) falls back to +(gs1, gs2).\n\n\n\n\n\n","category":"method"},{"location":"#Base.:+-Union{Tuple{T}, Tuple{T, T}} where T<:Distance","page":"Home","title":"Base.:+","text":"+(gs1::T, gs2::T) where {T<:Distance} performs the addition of the two Distance of the same type. It returns Distance of the same unit, with the value of their sum.\n\n\n\n\n\n","category":"method"},{"location":"#Base.:--Tuple{Any, Any}","page":"Home","title":"Base.:-","text":"Base.:-(gs1, gs2) do subtraction of gs1 and gs2 of the sameunit. It throws CoordinateMismatch error despite the following cases:\n\n\n\n\n\n","category":"method"},{"location":"#Base.:--Tuple{Coordinate, Distance}","page":"Home","title":"Base.:-","text":"Base.:-(gs1::Coordinate, gs2::Distance) returns a Distance. gs1::Coordinate can be subtracted by gs2::Distance.\n\n\n\n\n\n","category":"method"},{"location":"#Base.:--Tuple{Distance, Distance}","page":"Home","title":"Base.:-","text":"Base.:-(gs1::Distance, gs2::Distance) returns a Distance. gs1::Distance can be subtracted by gs2::Distance.\n\n\n\n\n\n","category":"method"},{"location":"#Base.:--Union{Tuple{T}, Tuple{T, T}} where T<:Coordinate","page":"Home","title":"Base.:-","text":"Base.:-(gs1::T, gs2::T) where {T<:Coordinate} returns a Distance. gs1 and gs2 of the same Coordinate can be subtracted.\n\n\n\n\n\n","category":"method"},{"location":"#EventSpaceAlgebra._create_add-Tuple{Any, Any}","page":"Home","title":"EventSpaceAlgebra._create_add","text":"_create_add(gs1, gs2) do sameunit check for gs1 and gs2, performs addition of their value, and return a copy of gs1 with the value of gs1 the sum of value of the input arguments.\n\n\n\n\n\n","category":"method"},{"location":"#EventSpaceAlgebra.disttype-Tuple{Type{<:EventSpaceAlgebra.Angular}}","page":"Home","title":"EventSpaceAlgebra.disttype","text":"Function disttype defines the one-to-one correspondance between U::GeneralUnit and T::Distance; it returns the type/constructor T. disttype is essential for Distance to construct an Distance struct.\n\nList:\n\ndisttype(::Type{<:Angular}) = AngularDistance\ndisttype(::Type{<:EpochTime}) = EpochDuration\n\n\n\n\n\n","category":"method"},{"location":"#EventSpaceAlgebra.sameunit-Tuple{Any, Any}","page":"Home","title":"EventSpaceAlgebra.sameunit","text":"Check if two objects of ValueUnit has the same unit.\n\n\n\n\n\n","category":"method"}]
}
