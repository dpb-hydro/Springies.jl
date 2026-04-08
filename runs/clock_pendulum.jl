# clock_pendulum.jl
# Dan Bartley, April 2026
# Damped pendulum with Heaviside external forcing

using Springies
using CairoMakie
using Printf

# Pendulum settings
m = 10.0
c = 0.7
L = 5.0

# External force
F0 = 5.0
thetac = 0.17
F_external = ClockForce(F0, thetac)

# Time settings
tspan = (0.0, 150.0)
Nt = 401
t = range(tspan...; length=Nt)

# Initial conditions [θ, dθ]
u0 = [deg2rad(-20.0), 0.0]

# Animation settings
savepath = joinpath(@__DIR__, "animations/clock_pendulum.gif")
fps = 10
window = 20.0

# Create pendulum object
pendulum = Pendulum1D(; m=m, c=c, L=L, F=F_external)

# Solve ODEs
@info "Solving ODE system..."
u_solved = springy_solve(pendulum, tspan, u0, Nt)
theta_rad = [u[1] for u in u_solved]
dtheta = [u[2] for u in u_solved]

# Derived values for plotting
x_bob = L .* sin.(theta_rad)       # Pendulum bob x position
y_bob = L .- L .* cos.(theta_rad)  # Pendulum bob y position
theta_deg = rad2deg.(theta_rad)    # Angle in radians

# Force arrow for plotting
F = F_external.(theta_rad, dtheta, 0.0)
F_scale = L / (2 * F0)
xF = 0.0
yF = L / 2

# Animate
framedir = joinpath(dirname(savepath), "frames")
mkpath(framedir)
fig = Figure(; size=(1200, 600))
ax1 = Axis(
    fig[1, 1];
    xlabel="x [m]",
    ylabel="y [m]",
    aspect=DataAspect(),
    limits=(-L * sind(30.0), L * sind(30.0), -0.25, L + 0.1),
)
ax2 = Axis(
    fig[1, 2];
    xlabel="Time [s]",
    ylabel="Displacement angle [deg]",
    limits=(0.0, window, -π, π),
    xticks=0.0:10.0:t[end],
)

x_bob_obs = Observable(x_bob[1])
y_bob_obs = Observable(y_bob[1])
x_rod_obs = Observable([0.0, x_bob[1]])
y_rod_obs = Observable([L, y_bob[1]])
xF_obs = Observable([xF])
yF_obs = Observable([yF])
u_obs = Observable([F[1] * F_scale])
v_obs = Observable([0.0])
t_seis_obs = Observable([t[1]])
theta_seis_obs = Observable([theta_deg[1]])
time_obs = Observable(@sprintf("t = %05.2f s", t[1]))

seis_ylim =
    1.05 * max(
        abs(minimum(theta_deg)),
        abs(maximum(theta_deg))
    )

text!(ax1, 0.02, 0.95; text=time_obs, space=:relative, fontsize=14, color=:grey) # Time label
lines!(ax1, [-L * 0.2, L * 0.2], [L, L]; color=:black, linewidth=4)              # Ceiling
lines!(ax1, x_rod_obs, y_rod_obs; color=:black, linewidth=2)                     # Rod
scatter!(ax1, x_bob_obs, y_bob_obs; markersize=20, color=:blue)                  # Bob
arrows2d!(ax1, xF_obs, yF_obs, u_obs, v_obs; lengthscale=0.2, color=:red) # Force arrow
Legend(
    fig[1, 1],
    [[PolyElement(; color=:red)]],
    ["Applied force"];
    tellwidth=false,
    tellheight=false,
    halign=:right,
    valign=:top,
    margin=(0, 20.0, 0, 10.0), # (L, R, B, T)
)

lines!(
    ax2,
    t_seis_obs,
    theta_seis_obs;
    color=:blue,
    linewidth=2,
)  # Seismograph
legend_entries = [
    [LineElement(; color=:blue, linewidth=2)],
]
Legend(
    fig[1, 2],
    legend_entries,
    ["Full response (numerical)"];
    tellwidth=false,
    tellheight=false,
    halign=:right,
    valign=:top,
    margin=(10, 10, 10, 10),
)

Label(fig[0, :], "Simple Clock Pendulum"; fontsize=20, font=:bold)
colsize!(fig.layout, 1, Relative(0.45))
colsize!(fig.layout, 2, Relative(0.55))

@info "Saving frames to $framedir"
for i in eachindex(x_bob)
    x_bob_obs[] = x_bob[i]
    y_bob_obs[] = y_bob[i]
    x_rod_obs[] = [0.0, x_bob[i]]
    y_rod_obs[] = [L, y_bob[i]]
    u_obs[] = [F[i] * F_scale]
    v_obs[] = [0.0]
    t_now = t[i]
    t_max = t_now + window / 2
    t_min = t_now - window / 2
    mask = t_min .<= t[1:i] .<= t_max
    t_seis_obs[] = t[1:i][mask]
    theta_seis_obs[] = theta_deg[1:i][mask]
    ax2.limits[] = (t_min, t_max, -seis_ylim, seis_ylim)
    time_obs[] = @sprintf("t = %05.2f s", t_now)
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
