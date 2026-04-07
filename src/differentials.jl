function differentials!(du::Vector{FT}, u::Vector{FT}, p::Springy{FT}, t::FT) where {FT<:AbstractFloat}
    throw(ArgumentError("Function differentials! not defined for argument p of type $(typeof(p))"))
end

"""
    damped_oscillation_ode!(du, u, p, t)

Internal function for `ode_numerical`.

Note variable ordering:
u  = [x, dx, y, dy, z, dz]
du = [dx, d^2x, dy, d^2y, dz, d^2z]
"""
function differentials!(du::Vector{FT}, u::Vector{FT}, p::Pendulum1D{FT}, t::FT) where {FT<:AbstractFloat}
    du[1] = u[2]
    du[2] = (p.F(u[1], 0.0, 0.0, t) / p.mL) - p.c_over_m * u[2] - p.g_over_L * sin(u[1])
end