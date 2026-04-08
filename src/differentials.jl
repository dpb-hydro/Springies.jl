"""
    differentials!(du, u, p::Springy{FT}, t)

Fallback method for `differentials!`. Throws an `ArgumentError` if no specialised
method is defined for the concrete type of `p`.

New `Springy` subtypes must implement their own `differentials!` method.
"""
function differentials!(
    du::Vector{FT}, u::Vector{FT}, p::Springy{FT}, t::FT
) where {FT<:AbstractFloat}
    throw(ArgumentError("differentials! not defined for argument p of type $(typeof(p))"))
end

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
