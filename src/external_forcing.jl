"""
    ZeroForce{FT} <: ForceField{FT}

Empty type to represent absence of external force.
"""
struct ZeroForce{FT} <: ForceField{FT}
    function ZeroForce(::Type{FT}) where {FT<:AbstractFloat}
        new{FT}()
    end
end

"""
    (f::ZeroForce{FT})(x::FT, y::FT, z::FT, t::FT) where {FT<:AbstractFloat}

Return zero to represent absence of external force.
"""
function (f::ZeroForce{FT})(x, y, z, t) where {FT<:AbstractFloat}
    zero(FT)
end

struct CosineForce{FT<:AbstractFloat} <: ForceField{FT}
    F0::FT
    omega::FT
end
(f::CosineForce)(x, y, z, t) = f.F0 * cos(f.omega * t)

struct ClockForce{FT<:AbstractFloat} <: ForceField{FT}
    F0::FT
    xc::FT
end
function (f::ClockForce)(x, y, z, t)
    abs(x) >= xc ? f.F0 : 0.0
end