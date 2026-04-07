using Springies
using CairoMakie
using Printf

# Pendulum settings
m = 10.0
c = 0.7
L = 5.0

# External force
F_external = ZeroForce(Float64)

# Time settings
tspan = (0.0, 150.0)
Nt = 401
t = range(tspan...; length=Nt)

# Initial conditions [x, dx]
u0 = [0.0, 1.0]

# Animation settings
savepath = joinpath(@__DIR__, "animations/unforced_pendulum.gif")
fps = 10

# Create pendulum object
pendulum = Pendulum1D(; m=m, c=c, L=L, F=F_external)

# Solve ODEs
u_solved = springy_solve(pendulum, tspan, u0, Nt)
theta_num = [u[1] for u in u_solved]
theta_deg = rad2deg.(theta_num)

# Animate
xs = L .* sin.(theta_num)
ys = L .- L .* cos.(theta_num)
F_scale = L / 20.0
xF = 0.0
yF = L / 2
window = 20.0

framedir = joinpath(dirname(savepath), "frames")
mkpath(framedir)

fig = Figure(; size=(1200, 600))
ax = Axis(
    fig[1, 1];
    xlabel="x",
    ylabel="y",
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

x_obs = Observable(xs[1])
y_obs = Observable(ys[1])
xF_obs = Observable([xF])
yF_obs = Observable([yF])
rod_x = Observable([0.0, xs[1]])
rod_y = Observable([L, ys[1]])
seis_t = Observable([t[1]])
seis_theta = Observable([theta_deg[1]])
seis_ylim = 1.05*max(
    abs(minimum(theta_deg)),
    abs(maximum(theta_deg))
)

time_obs = Observable(@sprintf("t = %05.2f s", t[1]))
text!(ax, 0.02, 0.95; text=time_obs, space=:relative, fontsize=14, color=:grey)

lines!(ax, [-L * 0.2, L * 0.2], [L, L]; color=:black, linewidth=4)
lines!(ax, rod_x, rod_y; color=:black, linewidth=2)
scatter!(ax, x_obs, y_obs; markersize=20, color=:blue)
lines!(ax2, seis_t, seis_theta; color=:blue, linewidth=2)

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

Label(fig[0, :], "Damped Pendulum"; fontsize=20, font=:bold)
colsize!(fig.layout, 1, Relative(0.45))
colsize!(fig.layout, 2, Relative(0.55))

@info "Saving frames to $framedir"
for i in eachindex(xs)
    x_obs[] = xs[i]
    y_obs[] = ys[i]
    rod_x[] = [0.0, xs[i]]
    rod_y[] = [L, ys[i]]
    xF_obs[] = [xF]
    yF_obs[] = [yF]


    t_now = t[i]
    t_max = t_now + window / 2
    t_min = t_now - window / 2
    mask = t_min .<= t[1:i] .<= t_max
    seis_t[] = t[1:i][mask]
    seis_theta[] = theta_deg[1:i][mask]
    ax2.limits[] = (t_min, t_max, -seis_ylim, seis_ylim)

    time_obs[] = @sprintf("t = %05.2f s", t_now)

    save(joinpath(framedir, @sprintf("frame_%06d.png", i)), fig; px_per_unit=1)
end

@info "Assembling animation with ffmpeg..."

# Pass 1: generate palette (stored outside framedir)
palette = joinpath(dirname(framedir), "palette.png")
run(`ffmpeg -y -framerate $fps -i $(joinpath(framedir, "frame_%06d.png")) -vf palettegen -update 1 $palette`,)

# Pass 2: encode with palette
run(`ffmpeg -y -framerate $fps -i $(joinpath(framedir, "frame_%06d.png")) -i $palette -lavfi paletteuse $savepath`,)

@info "Cleaning up..."
rm(framedir; recursive=true)
rm(palette)