"""
    gyre_ode!(du, u, G, t)

Wrapper function of Doule Gyre velocity field used by [advect_particles](@ref).

# Arguments
- `du`: velocity at each particle position (modified in-place)
- `u`: particle positions
- `G`: properties of Double Gyre field
- `t`: time
"""
function gyre_ode!(du, u, G::GyreProperties, t)
    for i in eachindex(axes(u, 2))
        du[:, i] = gyre_uv(G, u[1, i], u[2, i], t)
    end
end

"""
    advect_particles(u0, G, tspan)

Compute particle trajectories in the Double Gyre.

# Arguments
- `u0`: particle positions at `t[0]`
- `G`: properties of Double Gyre field
- `tspan`: time bounds
"""
function advect_particles(u0::AbstractArray, G::GyreProperties, tspan::NTuple{2,<:Real})
    prob = ODEProblem(gyre_ode!, u0, tspan, G)
    sol = solve(prob, RK4())
    return sol
end
