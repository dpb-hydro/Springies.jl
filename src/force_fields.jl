"""
    CosineForce{FT<:AbstractFloat} <: ForceField{FT}

One-dimensional cosine force.
"""
struct CosineForce{FT<:AbstractFloat} <: ForceField{FT}
    F0::FT
    omega::FT
end

(f::CosineForce)(x, y, z, t) = f.F0 * cos(f.omega * t)
