using Oscillations
using ForwardDiff
using CairoMakie
using Printf

# Types holding pendulum settings and applied force
include("types/gyre_types.jl")

# Spring settings
m = 5.0
c = 2.5
k = 10.0

# x0 = 1.0
# y0 = 0.75

# # Gyre settings
# gA = 0.1  # Magnitude control
# ge = 0.25 # Wobble size control
# gT = 10.0 # Wobble period
# G = GyreProperties(gA, ge, 2*π/gT)

# # Time settings
# # tspan = (0.0, T * 15)
# tspan = (0.0, gT * 3)
# Nt = 81
# t = range(tspan...; length=Nt)

# # Animation settings
# savepath = joinpath(@__DIR__, "double_gyre.gif")
# fps = 10
# nquiver=20

# # Initial conditions [x, dx, y, dy, z, dz]
# u0 = [x0, 0.0, y0, 0.0, 0.0, 0.0]

# # Create accelerator object
# spr_x = Spring1D(m, c, k, x0, y0)
# F_x = GyreFX(G)
# accn_x = Accelerator1D(spr_x, F_x, :x)

# spr_y = Spring1D(m, c, k, x0, y0)
# F_y = GyreFY(G)
# accn_y = Accelerator1D(spr_y, F_y, :y)

# accn = Accelerator3D(; x=accn_x, y=accn_y)

# # Solve ODEs
# u_solved = ode_numerical(accn, tspan, u0, Nt)
# xs = [u[1] for u in u_solved]
# ys = [u[3] for u in u_solved]

# # Animate 

# # Fixed coarse grid for quiver
# xq = range(0.0, 2.0; length=nquiver)
# yq = range(0.0, 1.0; length=nquiver ÷ 2)
# xgrid, ygrid = meshgrid_xy(xq, yq)

# fig = Figure(; size=(1200, 600))
# ax = Axis(
#     fig[1, 1]; xlabel="x", ylabel="y", aspect=DataAspect(), limits=(-0.1, 2.1, -0.1, 1.1)
# )

# # Observables for particles and quiver
# x_obs = Observable(xs[1])
# y_obs = Observable(ys[1])
# uv_obs = Observable([
#     gyre_uv(G, xgrid[i, j], ygrid[i, j], t[1]) for i in axes(xgrid, 1), j in axes(xgrid, 2)
# ])

# # Flatten quiver grid for arrows
# xq_flat = xgrid[:]
# yq_flat = ygrid[:]
# u_obs = Observable(first.(uv_obs[])[:])
# v_obs = Observable(last.(uv_obs[])[:])

# arrows2d!(ax, xq_flat, yq_flat, u_obs, v_obs; lengthscale=0.2, color=:grey)
# scatter!(ax, x_obs, y_obs; markersize=10, color=:blue)

# record(fig, savepath, eachindex(xs); framerate=fps, loop=0) do i
#     x_obs[] = xs[i]
#     y_obs[] = ys[i]
#     uv = [
#         gyre_uv(G, xgrid[k, l], ygrid[k, l], t[i]) for
#         k in axes(xgrid, 1), l in axes(xgrid, 2)
#     ]
#     u_obs[] = first.(uv)[:]
#     v_obs[] = last.(uv)[:]
#     ax.title[] = @sprintf("Double Gyre Particle Forcing  t = %05.2f", t[i])
# end
