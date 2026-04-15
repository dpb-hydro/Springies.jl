# grassy_gyres.jl
# Dan Bartley, April 2026
# Forcing grass blades in a Double Gyre force field.

using Springies
using CairoMakie
using Printf

# Spring settings
m = 5.0
c = 2.5
k = 2.5

# Gyre settings
A = 0.1  # Magnitude control
ϵ = 0.25 # Wobble size control
T = 10.0 # Wobble period

G = DoubleGyre(A, ϵ, 2 * pi / T)

# Time settings
tspan = (0.0, T * 15)
Nt = 401
t = range(tspan...; length=Nt)

# Initial conditions
nx, ny = 41, 21    # Number
Np = nx * ny
xc, yc = 1.0, 0.5  # Centre
Ax, Ay = 2.0, 1.0  # Extent
# method = :regular # [:regular/:random]
# xy0 = init_particles(nx, ny, xc, yc, Ax, Ay; method=method)
method = :random # [:regular/:random]
xy0 = init_particles(Np, xc, yc, Ax, Ay; method=method)
x0 = xy0[1, :]
y0 = xy0[2, :]
u0s = [x0'; zeros(Np)'; y0'; zeros(Np)']

# Animation settings
savepath = joinpath(@__DIR__, "animations/grassy_gyres.gif")
fps = 10
nquiver = 20

# Solve ODEs
@info "Solving ODE system..."
xs = zeros(Np, Nt)
ys = zeros(Np, Nt)
for i in 1:Np
    S = BendyStalk(m, c, k, x0[i], y0[i], G)
    u_solved = springy_solve(S, tspan, u0s[:, i], Nt)
    xs[i, :] = [u[1] for u in u_solved]
    ys[i, :] = [u[3] for u in u_solved]
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
    Springies.applied_force.(Ref(G), xgrid[i, j], ygrid[i, j], t[1]) for
    i in axes(xgrid, 1), j in axes(xgrid, 2)
])
time_obs = Observable(@sprintf("t = %05.2f s", t[1]))

ax.title = @sprintf("Grassy Double Gyre")

# Flatten quiver grid for arrows
xq_flat = xgrid[:]
yq_flat = ygrid[:]
u_obs = Observable(first.(uv_obs[])[:])
v_obs = Observable(last.(uv_obs[])[:])

arrows2d!(ax, xq_flat, yq_flat, u_obs, v_obs; lengthscale=0.2, color=:grey)
scatter!(ax, x_obs, y_obs; markersize=10, color=:darkolivegreen)
text!(ax, 0.02, 0.95; text=time_obs, space=:relative, fontsize=14, color=:grey) # Time label

for i in 1:Nt
    x_obs[] = xs[:, i]
    y_obs[] = ys[:, i]
    uv = [
        Springies.applied_force.(Ref(G), xgrid[k, l], ygrid[k, l], t[i]) for
        k in axes(xgrid, 1), l in axes(xgrid, 2)
    ]
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
