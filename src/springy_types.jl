# springy_types.jl
# Dan Bartley, April 2026
# Type definitions for Springies.

# ----------------------------------------------------------------------------------------------------------
# ABSTRACT SUPERTYPE
# ----------------------------------------------------------------------------------------------------------

"""
    Springy{FT<:AbstractFloat}

Abstract supertype for all Springies.

Subtypes must implement `differentials!(du, u, p::MyNewSpringy{FT}, t)`.
"""
abstract type Springy{FT<:AbstractFloat} end

# ----------------------------------------------------------------------------------------------------------
# PENDULUM1D
# ----------------------------------------------------------------------------------------------------------

"""
    Pendulum1D{FT,FF<:ForceField{FT}} <: Springy{FT}
    Pendulum1D(m, c, L; g=9.81, F=ZeroForce)

A damped, driven pendulum in 1D. The keyword constructor defaults to `g = 9.81`
and zero external forcing.

# Fields
- `m`: Mass
- `c`: Damping coefficient
- `L`: Pendulum length
- `g`: Gravitational acceleration
- `F`: External force field
- `mL`: Precomputed `m * L`
- `c_over_m`: Precomputed `c / m`
- `g_over_L`: Precomputed `g / L`
"""
struct Pendulum1D{FT,FF<:ForceField{FT}} <: Springy{FT}
    m::FT
    c::FT
    L::FT
    g::FT
    F::FF
    mL::FT
    c_over_m::FT
    g_over_L::FT
    function Pendulum1D(
        m::FT, c::FT, L::FT, g::FT, F::FF
    ) where {FT<:AbstractFloat,FF<:ForceField{FT}}
        return new{FT,FF}(m, c, L, g, F, m * L, c / m, g / L)
    end
end

function Pendulum1D(
    m::FT, c::FT, L::FT; g::FT=FT(9.81), F::ForceField{FT}=ZeroForce(FT)
) where {FT<:AbstractFloat}
    return Pendulum1D(m, c, L, g, F)
end

# ----------------------------------------------------------------------------------------------------------
# FREEPARTICLE2D
# ----------------------------------------------------------------------------------------------------------

"""
    FreeParticle2D{FT,FF<:ForceField{FT}} <: Springy{FT}

A massless particle that can be advected in two dimensions by a field.

# Fields
- `F`: External force field (conceptually this is a velocity field rather than a force field).
"""
struct FreeParticle2D{FT,FF<:ForceField{FT}} <: Springy{FT}
    F::FF
end

# ----------------------------------------------------------------------------------------------------------
# BENDYSTALK
# ----------------------------------------------------------------------------------------------------------

"""
    BendyStalk{FT,FF<:ForceField{FT}} <: Springy{FT}

A linear lumped mass model of a flexible mass-spring system. This is equivalent to two independent springs in the x and y directions.

# Fields
- `m`: Mass
- `c`: Damping coefficient
- `k`: Stiffness coefficent
- `x0`: Neutral position in x
- `y0`: Neutral position in y
- `F`: External force field
- `c_over_m`: Precomputed `c / m`
- `k_over_m`: Precomputed `k / m`
"""
struct BendyStalk{FT,FF<:ForceField{FT}} <: Springy{FT}
    m::FT
    c::FT
    k::FT
    x0::FT
    y0::FT
    F::FF
    c_over_m::FT
    k_over_m::FT
    function BendyStalk(
        m::FT, c::FT, k::FT, x0::FT, y0::FT, F::FF
    ) where {FT<:AbstractFloat,FF<:ForceField{FT}}
        return new{FT,FF}(m, c, k, x0, y0, F, c / m, k / m)
    end
end

# ----------------------------------------------------------------------------------------------------------
# THREEBODY
# ----------------------------------------------------------------------------------------------------------

"""
    ThreeBody{FT} <: Springy{FT}

The canonical Three-body Problem.

# Fields
- `m1`: Mass of particle 1
- `m2`: Mass of particle 2
- `m3`: Mass of particle 3
- `G`: Gravitational constant
"""
struct ThreeBody{FT} <: Springy{FT}
    m1::FT
    m2::FT
    m3::FT
    G::FT
end
