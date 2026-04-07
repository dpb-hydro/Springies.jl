"""
    Accelerator

Abstract supertype for all accelerators.
"""
abstract type Springy{FT<:AbstractFloat} end

"""
    ForceField{FT<:AbstractFloat}

Abstract supertype for all external force fields.
"""
abstract type ForceField{FT<:AbstractFloat} end