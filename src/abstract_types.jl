"""
    Springy{FT<:AbstractFloat}

Abstract supertype for all Springies.

Subtypes must implement `differentials!(du, u, p::MySpriny{FT}, t)`.
"""
abstract type Springy{FT<:AbstractFloat} end

"""
    ForceField{FT<:AbstractFloat}

Abstract supertype for all external force fields.

Subtypes must implement `(f::MyForce{FT})(x, y, z, t)`.
"""
abstract type ForceField{FT<:AbstractFloat} end
