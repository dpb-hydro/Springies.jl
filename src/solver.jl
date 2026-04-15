# solver.jl
# Dan Bartley, April 2026
# Main solver engine; wrapper of OrdinaryDiffEq.solve().

"""
    springy_solve(p::Springy{FT}, tspan::Tuple{FT,FT}, u0::Vector{FT}, Nt::Integer) where {FT<:AbstractFloat}

Wrapper of `OrdinaryDiffEq.solve`. Solve the ODE system defined by the Springy `p` and its corresponding `differentials!` function. Return the solution interpolated onto a uniform time grid.

# Arguments
- `p`: Springy instance
- `tspan`: Start and end times `(t0, t1)`
- `u0`: Initial state vector
- `Nt`: Number of time points in the output grid
"""
function springy_solve(
    p::Springy{FT}, tspan::Tuple{FT,FT}, u0::Vector{FT}, Nt::Integer
) where {FT<:AbstractFloat}
    prob = ODEProblem(differentials!, u0, tspan, p)    # type unstable; ODEProblem type is too complex, interpreted as ::Any
    sol_interpolated = solve_and_interpolate(prob, Nt) # Solution and interpolation logic in barrier function to isolate type instability
    return sol_interpolated
end

"""
    solve_and_interpolate(prob::ODEProblem, Nt)

Barrier function to isolate type instability arising from ODEProblem construction.
"""
function solve_and_interpolate(prob::ODEProblem, Nt::Integer)
    sol = solve(prob, Tsit5(); reltol=1e-8, abstol=1e-10)
    t = range(prob.tspan...; length=Nt)
    return sol(t)
end