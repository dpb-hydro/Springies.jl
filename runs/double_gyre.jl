# double_gyre.jl
# Dan Bartley, April 2026
# Advecting particles in the canonical double gyre velocity field.

using Springies
using CairoMakie
using Printf

# ----------------------------------------------------------------------------------------------------------
# COMPUTATION
# ----------------------------------------------------------------------------------------------------------

# Gyre settings
A = 0.1  # Magnitude control
ϵ = 0.25 # Wobble size control
T = 10.0 # Wobble period
G = DoubleGyre(A, ϵ, 2 * pi / T)
S = FreeParticle2D(G)

# Time settings
tspan = (0.0, T * 15)
Nt = 401
t = range(tspan...; length=Nt)

# Initial conditions
nx, ny = 15, 15    # Number
xc, yc = 0.5, 0.75 # Centre
Ax, Ay = 0.1, 0.1  # Extent
method = Grid() # [Grid()/Random()]
u0s = init_particles(nx, ny, xc, yc, Ax, Ay, method)
Np = nx * ny

# Solve ODEs
@info "Solving ODE system..."
xs = zeros(Np, Nt)
ys = zeros(Np, Nt)
for i in 1:Np
    u_solved = springy_solve(S, tspan, u0s[:, i], Nt)
    xs[i, :] = u_solved[1, :]
    ys[i, :] = u_solved[2, :]
end

# ----------------------------------------------------------------------------------------------------------
# ANIMATION
# ----------------------------------------------------------------------------------------------------------

# Animation settings
save_animation_as = joinpath(@__DIR__, "animations/double_gyre.gif")
framedir = make_framedir(save_animation_as)
fps = 10
nquiver = 20

# Fixed coarse grid for quiver
xq = range(0.0, 2.0; length=nquiver)
yq = range(0.0, 1.0; length=nquiver ÷ 2)
xgrid, ygrid = meshgrid_xy(xq, yq)

fig = Figure(; size=(1200, 600))
ax = Axis(
    fig[1, 1]; xlabel="x", ylabel="y", aspect=DataAspect(), limits=(-0.1, 2.1, -0.1, 1.1)
)
ax.title = @sprintf("Double Gyre Particle Advection")

# Initialise observables
x_obs = Observable(xs[:, 1])
y_obs = Observable(ys[:, 1])
uv_obs = Observable([
    Springies.applied_force.(Ref(G), xgrid[i, j], ygrid[i, j], t[1]) for
    i in axes(xgrid, 1), j in axes(xgrid, 2)
])
time_obs = Observable(@sprintf("t = %05.2f s", t[1]))

# Flatten quiver grid for arrows
xq_flat = xgrid[:]
yq_flat = ygrid[:]
u_obs = Observable(first.(uv_obs[])[:])
v_obs = Observable(last.(uv_obs[])[:])

arrows2d!(ax, xq_flat, yq_flat, u_obs, v_obs; lengthscale=0.2, color=:grey)
scatter!(ax, x_obs, y_obs; markersize=10, color=:blue)
text!(ax, 0.02, 0.95; text=time_obs, space=:relative, fontsize=14, color=:grey) # Time label

@info "Writing frames to $framedir..."
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

run_ffmpeg(framedir, fps, save_animation_as)

@info "Cleaning up..."
rm(framedir; recursive=true)
