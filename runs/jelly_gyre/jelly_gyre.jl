using Springy
using ForwardDiff
using CairoMakie
using Printf

# This is actually the grassy gyre; the jelly gyre would be more like an FE model

# Types holding spring settings and applied force
include("gyre_types.jl")

# Spring settings (5.0, 2.5, 1.0) (50.0, 10.0, 0.1)
m = 5.0
c = 2.5
k = 1.0

# Gyre settings
gA = 0.1  # Magnitude control
ge = 0.25 # Wobble size control
gT = 10.0 # Wobble period
G = GyreProperties(gA, ge, 2 * π / gT)

# Time settings
tspan = (0.0, gT * 30)
Nt = 401
t = range(tspan...; length=Nt)

# Initial conditions [x, dx, y, dy, z, dz]
nx = 81
ny = 41
xy = init_particles(nx, ny, 1.0, 0.5, 2.0, 1.0; method=:regular)
x0 = xy[1, :]
y0 = xy[2, :]
Np = nx * ny
u0s = [x0'; zeros(Np)'; y0'; zeros(Np)'; zeros(Np)'; zeros(Np)']

# Animation settings
savepath = joinpath(@__DIR__, "double_gyre.gif")
fps = 10
nquiver = 20

# Solve ODEs
xs = zeros(Np, Nt)
ys = zeros(Np, Nt)

for i in 1:Np
    spr_x = Spring1D(m, c, k, x0[i], y0[i])
    F_x = GyreFX(G)
    accn_x = Accelerator1D(spr_x, F_x, :x)

    spr_y = Spring1D(m, c, k, x0[i], y0[i])
    F_y = GyreFY(G)
    accn_y = Accelerator1D(spr_y, F_y, :y)

    accn = Accelerator3D(; x=accn_x, y=accn_y)

    u_solved = ode_numerical(accn, tspan, u0s[:, i], Nt)
    xs[i, :] = [u[1] for u in u_solved]
    ys[i, :] = [u[3] for u in u_solved]
end

# Animate 

# Fixed coarse grid for quiver
xq = range(0.0, 2.0; length=nquiver)
yq = range(0.0, 1.0; length=nquiver ÷ 2)
xgrid, ygrid = meshgrid_xy(xq, yq)

fig = Figure(; size=(1200, 600))
ax = Axis(
    fig[1, 1]; xlabel="x", ylabel="y", aspect=DataAspect(), limits=(-0.1, 2.1, -0.1, 1.1)
)

# Observables for particles and quiver
x_obs = Observable(xs[:, 1])
y_obs = Observable(ys[:, 1])
uv_obs = Observable([
    gyre_uv(G, xgrid[i, j], ygrid[i, j], t[1]) for i in axes(xgrid, 1), j in axes(xgrid, 2)
])

# Flatten quiver grid for arrows
xq_flat = xgrid[:]
yq_flat = ygrid[:]
u_obs = Observable(first.(uv_obs[])[:])
v_obs = Observable(last.(uv_obs[])[:])

arrows2d!(ax, xq_flat, yq_flat, u_obs, v_obs; lengthscale=0.2, color=:grey)
scatter!(ax, x_obs, y_obs; markersize=10, color=:blue)

framedir = joinpath(dirname(savepath), "frames")
mkpath(framedir)

for i in eachindex(t)
    x_obs[] = xs[:, i]
    y_obs[] = ys[:, i]
    uv = [
        gyre_uv(G, xgrid[k, l], ygrid[k, l], t[i]) for
        k in axes(xgrid, 1), l in axes(xgrid, 2)
    ]
    u_obs[] = first.(uv)[:]
    v_obs[] = last.(uv)[:]
    ax.title[] = @sprintf("Double Gyre Particle Forcing  t = %05.2f", t[i])

    save(joinpath(framedir, @sprintf("frame_%06d.png", i)), fig; px_per_unit=1)
end

@info "Assembling animation with ffmpeg..."
# Pass 1: generate palette (stored outside framedir)
palette = joinpath(dirname(framedir), "palette.png")
run(
    `ffmpeg -y -framerate $fps -i $(joinpath(framedir, "frame_%06d.png")) -vf palettegen -update 1 $palette`,
)

# Pass 2: encode with palette
run(
    `ffmpeg -y -framerate $fps -i $(joinpath(framedir, "frame_%06d.png")) -i $palette -lavfi paletteuse $savepath`,
)

@info "Cleaning up frames..."
rm(framedir; recursive=true)
