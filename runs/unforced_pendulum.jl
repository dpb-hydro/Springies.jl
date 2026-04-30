# unforced_pendulum.jl
# Dan Bartley, April 2026
# Damped pendulum with no external forcing.

using Springies
using CairoMakie
using Printf

# ----------------------------------------------------------------------------------------------------------
# COMPUTATION
# ----------------------------------------------------------------------------------------------------------

# Initialise pendulum
m = 10.0
c = 0.7
L = 5.0
pendulum = Pendulum1D(m, c, L)

# Time settings
tspan = (0.0, 100.0)
Nt = 376

# Initial conditions [θ, dθ]
# u0 = [deg2rad(-20.0), 0.0] # Release by dropping
u0 = [0.0, 0.5]              # Release by launching

# Solve ODEs
@info "Solving ODE system..."
u_solved = springy_solve(pendulum, tspan, u0, Nt)
theta_rad = u_solved[1, :]

# ----------------------------------------------------------------------------------------------------------
# ANIMATION
# ----------------------------------------------------------------------------------------------------------

# Animation settings
save_animation_as = joinpath(@__DIR__, "animations/unforced_pendulum.gif")
framedir = make_framedir(save_animation_as)
fps = 10
window = 20.0

# Derived values for plotting
t = range(tspan...; length=Nt)     # Time values
x_bob = L .* sin.(theta_rad)       # Pendulum bob x position
y_bob = L .- L .* cos.(theta_rad)  # Pendulum bob y position
theta_deg = rad2deg.(theta_rad)    # Angle in radians
seis_ylim = 1.05 * max(abs(minimum(theta_deg)), abs(maximum(theta_deg))) # y-limits of plot

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

# Initialise observables
x_bob_obs = Observable(x_bob[1])
y_bob_obs = Observable(y_bob[1])
x_rod_obs = Observable([0.0, x_bob[1]])
y_rod_obs = Observable([L, y_bob[1]])
t_seis_obs = Observable([t[1]])
theta_seis_obs = Observable([theta_deg[1]])
time_obs = Observable(@sprintf("t = %05.2f s", t[1]))

# Draw pendulum (ax1)
text!(ax1, 0.02, 0.95; text=time_obs, space=:relative, fontsize=14, color=:grey) # Time label
lines!(ax1, [-L * 0.2, L * 0.2], [L, L]; color=:black, linewidth=4)              # Ceiling
lines!(ax1, x_rod_obs, y_rod_obs; color=:black, linewidth=2)                     # Rod
scatter!(ax1, x_bob_obs, y_bob_obs; markersize=20, color=:blue)                  # Bob

# Plot graph (ax2)
lines!(
    ax2,
    t_seis_obs,
    theta_seis_obs;
    color=:blue,
    linewidth=2,
    label="Full response (numerical)",
)
axislegend(ax2; position=:rt, margin=(10, 10, 10, 10))

Label(fig[0, :], "Damped Pendulum"; fontsize=20, font=:bold)
colsize!(fig.layout, 1, Relative(0.45))
colsize!(fig.layout, 2, Relative(0.55))

@info "Writing frames to $framedir..."
for i in eachindex(x_bob)
    x_bob_obs[] = x_bob[i]
    y_bob_obs[] = y_bob[i]
    x_rod_obs[] = [0.0, x_bob[i]]
    y_rod_obs[] = [L, y_bob[i]]
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

run_ffmpeg(framedir, fps, save_animation_as)

@info "Cleaning up..."
rm(framedir; recursive=true)
