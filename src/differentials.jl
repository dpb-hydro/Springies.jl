# differentials.jl
# Dan Bartley, April 2026
# ODE definitions for Springy instances.

# ----------------------------------------------------------------------------------------------------------
# FALLBACK
# ----------------------------------------------------------------------------------------------------------

"""
    differentials!(du, u, p::Springy{FT}, t)

Fallback method for `differentials!`. Throw an `ArgumentError` if no specialised
method is defined for the concrete type of `p`.

New `Springy` subtypes must implement their own `differentials!` method.
"""
function differentials!(
    du::Vector{FT}, u::Vector{FT}, p::Springy{FT}, t::FT
) where {FT<:AbstractFloat}
    throw(ArgumentError("differentials! not defined for argument p of type $(typeof(p))"))
end

# ----------------------------------------------------------------------------------------------------------
# PENDULUM1D
# ----------------------------------------------------------------------------------------------------------

"""
    differentials!(du, u, p::Pendulum1D{FT}, t)

In-place ODE right-hand side for a [`Pendulum1D`](@ref).

State vector convention: `u = [θ, dθ/dt]`.
"""
function differentials!(
    du::Vector{FT}, u::Vector{FT}, p::Pendulum1D{FT}, t::FT
) where {FT<:AbstractFloat}
    du[1] = u[2]
    du[2] = (p.F(u[1], u[2], t) / p.mL) - p.c_over_m * u[2] - p.g_over_L * sin(u[1])
    return du
end

# ----------------------------------------------------------------------------------------------------------
# FREEPARTICLE2D
# ----------------------------------------------------------------------------------------------------------

"""
    differentials!(du, u, p::FreeParticle2D{FT}, t)

In-place ODE right-hand side for a [`FreeParticle2D`](@ref).

State vector convention: `u = [x, y]`.
"""
function differentials!(
    du::Vector{FT}, u::Vector{FT}, p::FreeParticle2D{FT}, t::FT
) where {FT<:AbstractFloat}
    uv = p.F(u[1], u[2], t)
    du[1] = uv[1]
    du[2] = uv[2]
    return du
end

# ----------------------------------------------------------------------------------------------------------
# BENDYSTALK
# ----------------------------------------------------------------------------------------------------------

"""
    differentials!(du, u, p::BendyStalk{FT}, t)

In-place ODE right-hand side for a [`BendyStalk`](@ref).

State vector convention: `u = [x, dx, y, dy]`.
"""
function differentials!(
    du::Vector{FT}, u::Vector{FT}, p::BendyStalk{FT}, t::FT
) where {FT<:AbstractFloat}
    uv = p.F(u[1], u[3], t)
    du[1] = u[2]
    du[2] = (uv[1] / p.m) - p.c_over_m * u[2] - p.k_over_m * (u[1] - p.x0)
    du[3] = u[4]
    du[4] = (uv[2] / p.m) - p.c_over_m * u[4] - p.k_over_m * (u[3] - p.y0)
    return du
end

# ----------------------------------------------------------------------------------------------------------
# THREEBODY
# ----------------------------------------------------------------------------------------------------------

"""
    differentials!(du, u, p::ThreeBody{FT}, t)

In-place ODE right-hand side for a [`ThreeBody`](@ref).

State vector convention: `u = [x1, y1, dx1, dy1, x2, y2, dx2, dy2, x3, y3, dx3, dy3]`.
"""
function Springies.differentials!(
    du::Vector{FT}, u::Vector{FT}, p::ThreeBody{FT}, t::FT
) where {FT<:AbstractFloat}
    dist = (x1, y1, x2, y2) -> hypot(x1 - x2, y1 - y2)
    r12 = dist(u[1], u[2], u[5], u[6])
    r13 = dist(u[1], u[2], u[9], u[10])
    r23 = dist(u[5], u[6], u[9], u[10])
    # Body 1 velocity
    du[1] = u[3]
    du[2] = u[4]
    # Body 1 acceleration
    du[3] = -p.G * (p.m2 * (u[1] - u[5]) / r12^3 + p.m3 * (u[1] - u[9]) / r13^3)
    du[4] = -p.G * (p.m2 * (u[2] - u[6]) / r12^3 + p.m3 * (u[2] - u[10]) / r13^3)
    # Body 2 velocity
    du[5] = u[7]
    du[6] = u[8]
    # Body 2 acceleration
    du[7] = -p.G * (p.m3 * (u[5] - u[9]) / r23^3 + p.m1 * (u[5] - u[1]) / r12^3)
    du[8] = -p.G * (p.m3 * (u[6] - u[10]) / r23^3 + p.m1 * (u[6] - u[2]) / r12^3)
    # Body 3 velocity
    du[9] = u[11]
    du[10] = u[12]
    # Body 3 acceleration
    du[11] = -p.G * (p.m1 * (u[9] - u[1]) / r13^3 + p.m2 * (u[9] - u[5]) / r23^3)
    du[12] = -p.G * (p.m1 * (u[10] - u[2]) / r13^3 + p.m2 * (u[10] - u[6]) / r23^3)
    return du
end
