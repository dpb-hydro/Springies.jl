"""
    Springy{FT<:AbstractFloat}

Abstract supertype for all Springies.

Subtypes must implement `differentials!(du, u, p::MyNewSpringy{FT}, t)`.
"""
abstract type Springy{FT<:AbstractFloat} end

"""
    ForceField{FT<:AbstractFloat}

Abstract supertype for all external force fields.

Subtypes must implement `(f::MyNewForce{FT})(x, y, z, t)`.
"""
abstract type ForceField{FT<:AbstractFloat} end
