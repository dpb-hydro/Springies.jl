using CairoMakie
using Printf
using CairoMakie
include("src/Oscillations.jl")
include("my_types.jl")

m = 10.0
c = 0.7
L = 5.0

T = 10.0
omega = 2 * pi / T
F0 = 10.0

tspan = (0.0, T * 15)
Nt = 401

u0 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

pend_x = osc.Pendulum1D(; m=m, c=c, L=L)
F_x = osc.CosineForce(F0, omega)
accn_x = osc.Accelerator1D(pend_x, F_x, :y)

accn = osc.Accelerator3D(; x=accn_x)

u_solved = osc.ode_numerical(accn, tspan, u0, Nt)
x = [u[1] for u in u_solved]

fig = Figure(; size=(1200, 600))
ax = Axis(fig[1, 1]; xlabel="x", ylabel="y")
lines!(ax, range(tspan...; length=Nt), x; color=:blue, linewidth=2)
fig
