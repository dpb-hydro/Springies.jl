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

State vector convention: `u = [θ, dθ/dt]` = angle (rad) and angular velocity (rad/s)
"""
function differentials!(
    du::Vector{FT}, u::Vector{FT}, p::Pendulum1D{FT}, t::FT
) where {FT<:AbstractFloat}
    du[1] = u[2]
    du[2] = (p.F(u[1], u[2], t) / p.mL) - p.c_over_m * u[2] - p.g_over_L * sin(u[1])
end
