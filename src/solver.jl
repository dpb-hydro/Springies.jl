"""
    damped_oscillation_ode!(du, u, p, t)
    
    u  = [x, dx, y, dy, z, dz]
    du = [dx, d^2x, dy, d^2y, dz, d^2z]
"""
function damped_oscillation_ode!(du, u, p::ODEPack, t)
    params = p.oscillator.x_osc

    Fi = p.F([u[1], u[3], u[5]], t)

    du[1] = u[2]
    du[2] = (Fi[1] - a2(params) * u[2] - a3(params) * u[1]) / a1(params)
    du[3] = u[4]
    du[4] = (Fi[2] - a2(params) * u[4] - a3(params) * u[3]) / a1(params)
    du[5] = u[6]
    du[6] = (Fi[3] - a2(params) * u[6] - a3(params) * u[5]) / a1(params)
end

function ode_numerical(p::ODEPack, tspan, u0, Nt)
    prob = ODEProblem(damped_oscillation_ode!, u0, tspan, p)
    sol = solve(prob, Tsit5(); reltol=1e-8, abstol=1e-10)
    return sol(range(tspan...; length=Nt))
end
