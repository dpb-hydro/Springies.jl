"""
    ZeroForce{FT} <: ForceField{FT}
    (f::ZeroForce{FT})(x, y, z, t)

Absence of external force. Return zero.
"""
struct ZeroForce{FT} <: ForceField{FT}
    function ZeroForce(::Type{FT}) where {FT<:AbstractFloat}
        new{FT}()
    end
end

(f::ZeroForce{FT})(x::FT, y::FT, z::FT, t::FT) where {FT<:AbstractFloat} = zero(FT)

"""
    CosineForce{FT} <: ForceField{FT}
    (f::CosineForce)(x, y, z, t)

A time-periodic external force of the form `F(t) = F0 * cos(ω * t)`. Return `F0 * cos(ω * t)`.

# Fields
- `F0`: Force amplitude
- `omega`: Angular frequency `ω`
"""
struct CosineForce{FT} <: ForceField{FT}
    F0::FT
    omega::FT
end

(f::CosineForce{FT})(x::FT, y::FT, z::FT, t::FT) where {FT<:AbstractFloat} = f.F0 * cos(f.omega * t)

"""
    ClockForce{FT} <: ForceField{FT}
    (f::ClockForce)(x, y, z, t)

An external force that is applied only when the position `x` is outside a threshold `xc`. Return `F0` when `|x| ≥ xc`, and zero otherwise.

# Fields
- `F0`: Force amplitude
- `xc`: Position threshold
"""
struct ClockForce{FT} <: ForceField{FT}
    F0::FT
    xc::FT
end

(f::ClockForce{FT})(x::FT, y::FT, z::FT, t::FT) where {FT<:AbstractFloat} = abs(x) >= f.xc ? f.F0 : zero(FT)
