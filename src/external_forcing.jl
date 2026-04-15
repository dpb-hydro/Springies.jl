# external_forcing.jl
# Dan Bartley, April 2026
# Concrete type definitions for external forcing.

# ----------------------------------------------------------------------------------------------------------
# ABSTRACT SUPERTYPE
# ----------------------------------------------------------------------------------------------------------

"""
    ForceField{FT<:AbstractFloat}

Abstract supertype for all externally applied forces.

Subtypes must have corresponding method for `applied_force` which returns value of force at given coordinates.
"""
abstract type ForceField{FT<:AbstractFloat} end

# ----------------------------------------------------------------------------------------------------------
# ZEROFORCE
# ----------------------------------------------------------------------------------------------------------

"""
    ZeroForce{FT} <: ForceField{FT}

Type for absence of external force.

For use with [`Pendulum1D`](@ref) springies.
"""
struct ZeroForce{FT} <: ForceField{FT}
    function ZeroForce(::Type{FT}) where {FT<:AbstractFloat}
        return new{FT}()
    end
end

function applied_force(
    ::ZeroForce{FT}, theta::FT, dtheta::FT, t::FT
) where {FT<:AbstractFloat}
    return zero(FT)
end

# ----------------------------------------------------------------------------------------------------------
# COSINEFORCE
# ----------------------------------------------------------------------------------------------------------

"""
    CosineForce{FT} <: ForceField{FT}

Type for a time-periodic external force of form `F0 * cos(ω * t)`.

For use with [`Pendulum1D`](@ref) springies.
"""
struct CosineForce{FT} <: ForceField{FT}
    F0::FT
    omega::FT
end

function applied_force(
    f::CosineForce{FT}, theta::FT, dtheta::FT, t::FT
) where {FT<:AbstractFloat}
    return f.F0 * cos(f.omega * t)
end

# ----------------------------------------------------------------------------------------------------------
# CLOCKFORCE
# ----------------------------------------------------------------------------------------------------------

"""
    ClockForce{FT} <: ForceField{FT}
    (f::ClockForce)(θ, dθ, t)

Type for an external force that is applied only when pendulum is moving outwards and outside a threshold `θc`. Return `F0` when these criteria are met, and zero otherwise.

For use with [`Pendulum1D`](@ref) springies.

# Fields
- `F0`: Force amplitude
- `θc`: Position threshold
"""
struct ClockForce{FT} <: ForceField{FT}
    F0::FT
    thetac::FT
end

function applied_force(
    f::ClockForce{FT}, theta::FT, dtheta::FT, t::FT
) where {FT<:AbstractFloat}
    if abs(theta) >= f.thetac && sign(theta) == sign(dtheta)
        return sign(theta) * f.F0
    else
        return zero(FT)
    end
end

# ----------------------------------------------------------------------------------------------------------
# DOUBLEGYRE
# ----------------------------------------------------------------------------------------------------------

"""
    DoubleGyre{FT} <: ForceField{FT}
    (f::DoubleGyre)(x, y, t)

The canonical Double Gyre field. Functor returns `[u, v]`, the x and y components of the field, respectively.

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

"""
    gyre_stream(G::DoubleGyre, x::Real, y::Real, t::Real)
    
(Helper function) Stream function of the Double Gyre field.

# Arguments
- `G`: a [`DoubleGyre`](@ref) instance
- `x`, `y`, `t`: coordinate values of x, y, and t
"""
function gyre_stream(G::DoubleGyre, x::Real, y::Real, t::Real) # ::Real is needed as a looser constraint for ForwardDiff
    a = G.e * sin(G.omega * t)
    fx = a * x^2 + (1 - 2a) * x
    return G.A * sin(pi * fx) * sin(pi * y)
end

function applied_force(f::DoubleGyre{FT}, x::FT, y::FT, t::FT) where {FT<:AbstractFloat}
    u = -ForwardDiff.derivative(a -> gyre_stream(f, x, a, t), y)
    v = ForwardDiff.derivative(b -> gyre_stream(f, b, y, t), x)
    return u, v
end
