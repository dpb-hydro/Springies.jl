"""
    Pendulum1D{FT} <: Springy{FT}
    Pendulum1D(; m, c, L, g=9.81, F=nothing)

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
struct Pendulum1D{FT} <: Springy{FT}
    m::FT
    c::FT
    L::FT
    g::FT
    F::ForceField{FT}
    mL::FT
    c_over_m::FT
    g_over_L::FT
    function Pendulum1D(m::T, c::T, L::T, g::T, F::ForceField{T}) where {T<:AbstractFloat}
        new{T}(m, c, L, g, F, m * L, c / m, g / L)
    end
end

function Pendulum1D(;
    m::T, c::T, L::T, F::Union{ForceField{T},Nothing}=nothing, g::AbstractFloat=9.81
) where {T<:AbstractFloat}
    Pendulum1D(m, c, L, T(g), isnothing(F) ? ZeroForce(T) : F)
end

"""
    FreeParticle2D{FT} <: Springy{FT}

A particle that can be advected in two dimensions by a field.

# Fields
- `F`: External force field (conceptually this is a velocity field rather than a force field).
"""
struct FreeParticle2D{FT} <: Springy{FT}
    F::ForceField{FT}
end

"""
    BendyStalk{FT} <: Springy{FT}

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
struct BendyStalk{FT} <: Springy{FT}
    m::FT
    c::FT
    k::FT
    x0::FT
    y0::FT
    F::ForceField{FT}
    c_over_m::FT
    k_over_m::FT
    function BendyStalk(m::T, c::T, k::T, x0::T, y0::T, F::ForceField{T}) where {T<:AbstractFloat}
        new{T}(m, c, k, x0, y0, F, c / m, k / m)
    end
end