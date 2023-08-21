abstract type AbstractSpace end

"""
Abstract type `GeneralSpace` are the supertype for all dimension/coordinate specification concrete `struct`s of `ValueUnit`, such as `Longitude`, `Latitude` and `EventTime`.
"""
abstract type GeneralSpace <: AbstractSpace end
abstract type Spatial <: GeneralSpace end
abstract type Temporal <: GeneralSpace end


abstract type GeneralUnit end
abstract type Angular <: GeneralUnit end
abstract type EpochTime <: GeneralUnit end


"""
`Distance` is the supertype for all types of "distance" on "GeneralSpace".
- Distance derived from multiple dimensional is beyond the scope of `Distance`.
- Each concrete struct of `GeneralUnit` corresponds to the only concrete struct of `Distance`
"""
abstract type Distance <: AbstractSpace end
