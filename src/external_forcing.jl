"""
    ZeroForce{FT} <: ForceField{FT}
    (f::ZeroForce{FT})(θ, dθ, t)

Absence of external force. Return zero.

For use with [`Pendulum1D`](@ref) springies.
"""
struct ZeroForce{FT} <: ForceField{FT}
    function ZeroForce(::Type{FT}) where {FT<:AbstractFloat}
        return new{FT}()
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
    return f.F0 * cos(f.omega * t)
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

"""
    DoubleGyre{FT} <: ForceField{FT}
    (f::DoubleGyre)(x, y, t)

The canonical Double Gyre field.

# Fields
- `A`: Velocity magnitude control
- `e`: Wobble size control
- `omega`: Wobble angular frequency
"""
struct DoubleGyre{FT} <: ForceField{FT}
    A::FT
    e::FT
    omega::FT
end

function gyre_stream(G::DoubleGyre, x::Real, y::Real, t::Real) # ::Real is needed as a looser constraint for ForwardDiff
    a = G.e * sin(G.omega * t)
    fx = a * x^2 + (1 - 2a) * x
    return G.A * sin(pi * fx) * sin(pi * y)
end

function (f::DoubleGyre{FT})(x::FT, y::FT, t::FT) where {FT<:AbstractFloat}
    u = -ForwardDiff.derivative(a -> gyre_stream(f, x, a, t), y)
    v = ForwardDiff.derivative(b -> gyre_stream(f, b, y, t), x)
    return [u, v]
end
