# double_gyre.jl
# Dan Bartley, April 2026
# Advecting particles in the canonical double gyre velocity field

using Springies
using CairoMakie
using Printf

# Gyre settings
A = 0.1  # Magnitude control
ϵ = 0.25 # Wobble size control
T = 10.0 # Wobble period
G = DoubleGyre(A, ϵ, 2*pi/T)
S = FreeParticle2D(G)

# Time settings
tspan = (0.0, T * 15)
Nt = 401
t = range(tspan...; length=Nt)

# Initial conditions
nx = 15   # Number
xc = 0.5  # Centre
Ax = 0.1  # Extent
ny = 15   # Number
yc = 0.75 # Centre
Ay = 0.1  # Extent
method = :regular # [:regular/:rand]
u0s = init_particles(nx, ny, xc, yc, Ax, Ay; method=method)
Np = nx*ny

# Animation settings
savepath = joinpath(@__DIR__, "animations/double_gyre.gif")
fps = 10
nquiver = 20

# Solve ODEs
@info "Solving ODE system..."
xs = zeros(Np, Nt)
ys = zeros(Np, Nt)
for i in 1:Np
    u_solved = springy_solve(S, tspan, u0s[:, i], Nt)
    xs[i, :] = [u[1] for u in u_solved]
    ys[i, :] = [u[2] for u in u_solved]
end

# Fixed coarse grid for quiver
xq = range(0.0, 2.0; length=nquiver)
yq = range(0.0, 1.0; length=nquiver ÷ 2)
xgrid, ygrid = meshgrid_xy(xq, yq)

framedir = joinpath(dirname(savepath), "frames")
mkpath(framedir)
@info "Saving frames to $framedir"
fig = Figure(; size=(1200, 600))
ax = Axis(
    fig[1, 1]; xlabel="x", ylabel="y", aspect=DataAspect(), limits=(-0.1, 2.1, -0.1, 1.1)
)

# Observables for particles and quiver
x_obs = Observable(xs[:, 1])
y_obs = Observable(ys[:, 1])
uv_obs = Observable([
    G.(xgrid[i, j], ygrid[i, j], t[1]) for i in axes(xgrid, 1), j in axes(xgrid, 2)
])
time_obs = Observable(@sprintf("t = %05.2f s", t[1]))

ax.title = @sprintf("Double Gyre Particle Advection")

# Flatten quiver grid for arrows
xq_flat = xgrid[:]
yq_flat = ygrid[:]
u_obs = Observable(first.(uv_obs[])[:])
v_obs = Observable(last.(uv_obs[])[:])

arrows2d!(ax, xq_flat, yq_flat, u_obs, v_obs; lengthscale=0.2, color=:grey)
scatter!(ax, x_obs, y_obs; markersize=10, color=:blue)
text!(ax, 0.02, 0.95; text=time_obs, space=:relative, fontsize=14, color=:grey) # Time label

for i in 1:Np
    x_obs[] = xs[:, i]
    y_obs[] = ys[:, i]
    uv = [G.(xgrid[k, l], ygrid[k, l], t[i]) for k in axes(xgrid, 1), l in axes(xgrid, 2)]
    u_obs[] = first.(uv)[:]
    v_obs[] = last.(uv)[:]
    time_obs[] = @sprintf("t = %05.2f s", t[i])
    save(joinpath(framedir, @sprintf("frame_%06d.png", i)), fig; px_per_unit=1)
end

@info "Assembling animation with ffmpeg..."
# Two passes of ffmpeg: pass 1 = generate palette, pass 2 = encode with palette
palette = joinpath(dirname(framedir), "palette.png")
run(
    `ffmpeg -y -framerate $fps -i $(joinpath(framedir, "frame_%06d.png")) -vf palettegen -update 1 $palette`,
)
run(
    `ffmpeg -y -framerate $fps -i $(joinpath(framedir, "frame_%06d.png")) -i $palette -lavfi paletteuse $savepath`,
)

@info "Cleaning up..."
rm(framedir; recursive=true)
rm(palette)
