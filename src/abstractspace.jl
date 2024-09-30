"""
Abstract type `AbstractCoordinate` are the supertype for all dimension/coordinate specification, such as `Longitude`, `Latitude` and `EventTime`.
"""
abstract type AbstractCoordinate{U} <: AbstractSpace end

# TODO: Use Holy trait for dispatching "spatial" (e.g., Longitude) and "temporal" (e.g., eventTime) Coordinate.
