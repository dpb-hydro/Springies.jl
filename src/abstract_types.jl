# abstract_types.jl
# Dan Bartley, April 2026
# Abstract supertype definitions

"""
    ForceField{FT<:AbstractFloat}

Abstract supertype for all external force fields.

Subtypes must implement callable functor giving value of force at input coordinates.
"""
abstract type ForceField{FT<:AbstractFloat} end

"""
    Springy{FT<:AbstractFloat}

Abstract supertype for all Springies.

Subtypes must implement `differentials!(du, u, p::MyNewSpringy{FT}, t)`.
"""
abstract type Springy{FT<:AbstractFloat} end
