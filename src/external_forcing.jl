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

"""
    CosineForce{FT<:AbstractFloat} <: ForceField{FT}

A time-periodic external force of the form `F(t) = F0 * cos(ω * t)`.

# Fields
- `F0`: Force amplitude
- `omega`: Angular frequency `ω`
"""
struct CosineForce{FT<:AbstractFloat} <: ForceField{FT}
    F0::FT
    omega::FT
end

"""
    (f::CosineForce)(x, y, z, t)

Return `F0 * cos(ω * t)`.
"""
(f::CosineForce)(x, y, z, t) = f.F0 * cos(f.omega * t)

"""
    ClockForce{FT<:AbstractFloat} <: ForceField{FT}

An external force that is applied only when the position `x` is outside a threshold `xc`.
Returns `F0` when `|x| ≥ xc`, and zero otherwise.

# Fields
- `F0`: Force amplitude
- `xc`: Position threshold
"""
struct ClockForce{FT<:AbstractFloat} <: ForceField{FT}
    F0::FT
    xc::FT
end

"""
    (f::ClockForce)(x, y, z, t)

Return `F0` if `|x| ≥ xc`, otherwise return `0`.
"""
function (f::ClockForce)(x, y, z, t)
    abs(x) >= xc ? f.F0 : 0.0
end
