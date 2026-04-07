"""
    Springy{FT<:AbstractFloat}

Abstract supertype for all Springies.
"""
abstract type Springy{FT<:AbstractFloat} end

"""
    ForceField{FT<:AbstractFloat}

Abstract supertype for all external force fields.
"""
abstract type ForceField{FT<:AbstractFloat} end
