function springy_solve(p::Springy, tspan, u0, Nt)
    prob = ODEProblem(differentials!, u0, tspan, p)
    sol = solve(prob, Tsit5(); reltol=1e-8, abstol=1e-10)
    return sol(range(tspan...; length=Nt))
end