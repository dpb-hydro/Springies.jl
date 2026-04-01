using CairoMakie
using Printf
using CairoMakie
include("src/Oscillations.jl")

m = 0.001
c = 1.0
L = 1.0

T = 10.0
omega = 2 * pi / T
F0 = 10.0

tspan = (0.0, T * 15)
Nt = 401

pend_x = osc.Pendulum1D(; m=m, c=c, L=L)
F_x = osc.CosineForce(F0, omega)
accn_x = osc.Accelerator1D(pend_x, F_x)

accn = osc.Accelerator3D(; x=accn_x)

# a1 = osc.Accelerator1D(pend, force)

# u0 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

# F = (xyz, t) -> Oscillations.cosine_x(xyz, t, F0, omega)

# ox = Pendulum1D(; m=m, c=c, L=L)
# pend = Oscillator3D(x_osc=ox)
# p = ODEPack(pend, F)

# x, y, z = ode_numerical(p, tspan, u0, Nt)

# fig = Figure(size=(1200, 600))
# ax = Axis(fig[1, 1],
#     xlabel="x",
#     ylabel="y",
# )
# lines!(ax, range(tspan..., length=Nt), y, color=:blue, linewidth=2)
# fig
