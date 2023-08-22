abstract type AbstractSpace end

"""
Abstract type `Coordinate` are the supertype for all dimension/coordinate specification concrete `struct`s of `ValueUnit`, such as `Longitude`, `Latitude` and `EventTime`.
"""
abstract type Coordinate <: AbstractSpace end
abstract type Spatial <: Coordinate end
abstract type Temporal <: Coordinate end


abstract type GeneralUnit end
abstract type Angular <: GeneralUnit end
abstract type EpochTime <: GeneralUnit end


"""
`Distance` is the supertype for all types of "distance" on "Coordinate".
- Distance derived from multiple dimensional is beyond the scope of `Distance`.
- Each concrete struct of `GeneralUnit` corresponds to the only concrete struct of `Distance`
"""
abstract type Distance <: AbstractSpace end
