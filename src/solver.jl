"""
    springy_solve(p::Springy{FT}, tspan::Tuple{FT,FT}, u0::Vector{FT}, Nt::Integer) where {FT<:AbstractFloat}

Solve the ODE system defined by the Springy `p` and its corresponding `differentials!` function. Return the solution interpolated onto a uniform time grid.

Wrapper for `OrdinaryDiffEq.solve`.

# Arguments
- `p`: Springy object.
- `tspan`: Start and end times `(t0, t1)`.
- `u0`: Initial state vector.
- `Nt`: Number of time points in the output grid.
"""
function springy_solve(
    p::Springy{FT}, tspan::Tuple{FT,FT}, u0::Vector{FT}, Nt::Integer
) where {FT<:AbstractFloat}
    prob = ODEProblem(differentials!, u0, tspan, p)
    sol = solve(prob, Tsit5(); reltol=1e-8, abstol=1e-10)
    sol_interpolated = sol(range(tspan...; length=Nt))
    return sol_interpolated
end
