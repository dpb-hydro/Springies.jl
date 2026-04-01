"""
    damped_oscillation_ode!(du, u, p, t)
    
    u  = [x, dx, y, dy, z, dz]
    du = [dx, d^2x, dy, d^2y, dz, d^2z]
"""
function damped_oscillation_ode!(du, u, p::Accelerator3D, t)
    du[1] = u[2]
    du[2] = p.x(u..., t)
    du[3] = u[4]
    du[4] = p.y(u..., t)
    du[5] = u[6]
    du[6] = p.z(u..., t)
end

function ode_numerical(p::Accelerator3D, tspan, u0, Nt)
    prob = ODEProblem(damped_oscillation_ode!, u0, tspan, p)
    sol = solve(prob, Tsit5(); reltol=1e-8, abstol=1e-10)
    return sol(range(tspan...; length=Nt))
end
