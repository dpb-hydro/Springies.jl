"""
    ZeroForce{FT} <: ForceField{FT}
    (f::ZeroForce{FT})(θ, dθ, t)

Absence of external force. Return zero.

For use with [`Pendulum1D`](@ref) springies.
"""
struct ZeroForce{FT} <: ForceField{FT}
    function ZeroForce(::Type{FT}) where {FT<:AbstractFloat}
        new{FT}()
    end
end

(f::ZeroForce{FT})(theta::FT, dtheta::FT, t::FT) where {FT<:AbstractFloat} = zero(FT)

"""
    CosineForce{FT} <: ForceField{FT}
    (f::CosineForce)(θ, dθ, t)

A time-periodic external force of the form `F(t) = F0 * cos(ω * t)`. Return `F0 * cos(ω * t)`.

For use with [`Pendulum1D`](@ref) springies.

# Fields
- `F0`: Force amplitude
- `omega`: Angular frequency `ω`
"""
struct CosineForce{FT} <: ForceField{FT}
    F0::FT
    omega::FT
end

function (f::CosineForce{FT})(theta::FT, dtheta::FT, t::FT) where {FT<:AbstractFloat}
    f.F0 * cos(f.omega * t)
end

"""
    ClockForce{FT} <: ForceField{FT}
    (f::ClockForce)(θ, dθ, t)

An external force that is applied only when the position `θ` is outside a threshold `θc`. Return `F0` when `|θ| ≥ θc`, and zero otherwise.

For use with [`Pendulum1D`](@ref) springies.

# Fields
- `F0`: Force amplitude
- `θc`: Position threshold
"""
struct ClockForce{FT} <: ForceField{FT}
    F0::FT
    thetac::FT
end

function (f::ClockForce{FT})(theta::FT, dtheta::FT, t::FT) where {FT<:AbstractFloat}
    if abs(theta) >= f.thetac && sign(theta) == sign(dtheta)
        return sign(theta) * f.F0
    else
        return zero(FT)
    end
end
