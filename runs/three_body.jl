# three_body.jl
# Dan Bartley, April 2026
# The canonical Three-body Problem.

using Springies
using CairoMakie
using Printf

# ----------------------------------------------------------------------------------------------------------
# COMPUTATION
# ----------------------------------------------------------------------------------------------------------

# Dimensionless units: G = 1, m = 1
G = 1.0
m1 = 1.0
m2 = 1.0
m3 = 1.0
S = ThreeBody(m1, m2, m3, G)

# Time settings
tspan = (0.0, 18.0)
Nt = 401
t = range(tspan...; length=Nt)

# Initial conditions
x1, y1 = -0.91, 0.27
x2, y2 = 0.97, -0.24
x3, y3 = 0.0, 0.1
dx1, dy1 = 0.4, 0.4
dx2, dy2 = 0.5, 0.5
dx3, dy3 = -1.0, -0.8
u0 = [x1, y1, dx1, dy1, x2, y2, dx2, dy2, x3, y3, dx3, dy3]

@info "Solving ODE system..."
u_solved = springy_solve(S, tspan, u0, Nt)
xs1 = u_solved[1, :]
ys1 = u_solved[2, :]
xs2 = u_solved[5, :]
ys2 = u_solved[6, :]
xs3 = u_solved[9, :]
ys3 = u_solved[10, :]

xlim = 1.05 * max(maximum(abs.(xs1)), maximum(abs.(xs2)), maximum(abs.(xs3)))
ylim = 1.05 * max(maximum(abs.(ys1)), maximum(abs.(ys2)), maximum(abs.(ys3)))

# ----------------------------------------------------------------------------------------------------------
# ANIMATION
# ----------------------------------------------------------------------------------------------------------

# Animation settings
save_animation_as = joinpath(@__DIR__, "animations/three_body.gif")
framedir = make_framedir(save_animation_as)
fps = 30
trail_len = 80  # number of past frames to show as trail

colors = [:cornflowerblue, :tomato, :mediumseagreen]

fig = Figure(; size=(800, 600), backgroundcolor=:black)
ax = Axis(
    fig[1, 1];
    xlabel="x",
    ylabel="y",
    aspect=DataAspect(),
    backgroundcolor=:black,
    xgridcolor=:grey20,
    ygridcolor=:grey20,
    xticklabelcolor=:grey60,
    yticklabelcolor=:grey60,
    xlabelcolor=:grey60,
    ylabelcolor=:grey60,
    limits=(-xlim, xlim, -ylim, ylim),
)
ax.title = "Three-Body Problem"
ax.titlecolor = :white

# Initialise observables
time_obs = Observable(@sprintf("t = %.2f", t[1]))
text!(ax, 0.02, 0.96; text=time_obs, space=:relative, fontsize=14, color=:grey60)

trail1_x = Observable(xs1[1:1])
trail1_y = Observable(ys1[1:1])
trail2_x = Observable(xs2[1:1])
trail2_y = Observable(ys2[1:1])
trail3_x = Observable(xs3[1:1])
trail3_y = Observable(ys3[1:1])

dot1_x = Observable([xs1[1]])
dot1_y = Observable([ys1[1]])
dot2_x = Observable([xs2[1]])
dot2_y = Observable([ys2[1]])
dot3_x = Observable([xs3[1]])
dot3_y = Observable([ys3[1]])

lines!(ax, trail1_x, trail1_y; color=colors[1], linewidth=1.5, alpha=0.6)
lines!(ax, trail2_x, trail2_y; color=colors[2], linewidth=1.5, alpha=0.6)
lines!(ax, trail3_x, trail3_y; color=colors[3], linewidth=1.5, alpha=0.6)

scatter!(ax, dot1_x, dot1_y; color=colors[1], markersize=16)
scatter!(ax, dot2_x, dot2_y; color=colors[2], markersize=16)
scatter!(ax, dot3_x, dot3_y; color=colors[3], markersize=16)

@info "Writing frames to $framedir..."
for i in 1:Nt
    i0 = max(1, i - trail_len)
    trail1_x[] = xs1[i0:i]
    trail1_y[] = ys1[i0:i]
    trail2_x[] = xs2[i0:i]
    trail2_y[] = ys2[i0:i]
    trail3_x[] = xs3[i0:i]
    trail3_y[] = ys3[i0:i]
    dot1_x[] = [xs1[i]]
    dot1_y[] = [ys1[i]]
    dot2_x[] = [xs2[i]]
    dot2_y[] = [ys2[i]]
    dot3_x[] = [xs3[i]]
    dot3_y[] = [ys3[i]]
    time_obs[] = @sprintf("t = %.2f", t[i])
    save(joinpath(framedir, @sprintf("frame_%06d.png", i)), fig; px_per_unit=1)
end

run_ffmpeg(framedir, fps, save_animation_as)

@info "Cleaning up..."
rm(framedir; recursive=true)
