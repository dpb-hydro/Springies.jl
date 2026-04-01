"""
    animate_pendulum(p, t, theta_num, theta_long, savepath; fps)
Create an animation of a damped forced pendulum simulation.
# Arguments
- `p`: pendulum properties (see [`Pendulum`](@ref))
- `t`: time vector
- `theta_num`: numerical solution for displacement angle [rad]
- `theta_long`: analytical steady-state solution for displacement angle [rad]
- `savepath`: path to save the output video
- `fps`: frames per second (default: 10)
"""
function animate(p::DampedPendulum, t, theta_num, theta_long, savepath::String; fps=10)
    xs = p.L .* sin.(theta_num)
    ys = p.L .- p.L .* cos.(theta_num)
    F = p.F0 .* cos.(p.omega .* t)
    F_scale = p.L / (2 * p.F0)
    xF = 0.0
    yF = p.L / 2
    window = 20.0

    framedir = joinpath(dirname(savepath), "frames")
    mkpath(framedir)

    fig = Figure(; size=(1200, 600))
    ax = Axis(
        fig[1, 1];
        xlabel="x",
        ylabel="y",
        aspect=DataAspect(),
        limits=(-p.L * sind(30.0), p.L * sind(30.0), -0.25, p.L + 0.1),
    )
    ax2 = Axis(
        fig[1, 2];
        xlabel="Time [s]",
        ylabel="Displacement angle [rad]",
        limits=(0.0, window, -π, π),
        xticks=0.0:10.0:t[end],
    )

    x_obs = Observable(xs[1])
    y_obs = Observable(ys[1])
    xF_obs = Observable([xF])
    yF_obs = Observable([yF])
    u_obs = Observable([F[1] * F_scale])
    v_obs = Observable([0.0])
    rod_x = Observable([0.0, xs[1]])
    rod_y = Observable([p.L, ys[1]])
    seis_t = Observable([t[1]])
    seis_theta = Observable([theta_num[1]])
    seis_ylim = max(
        abs(minimum(theta_num)),
        abs(maximum(theta_num)),
        abs(minimum(theta_long)),
        abs(maximum(theta_long)),
    )

    time_obs = Observable(@sprintf("t = %05.2f s", t[1]))
    text!(ax, 0.02, 0.95; text=time_obs, space=:relative, fontsize=14, color=:grey)

    lines!(ax, [-p.L * 0.2, p.L * 0.2], [p.L, p.L]; color=:black, linewidth=4)
    lines!(ax, rod_x, rod_y; color=:black, linewidth=2)
    scatter!(ax, x_obs, y_obs; markersize=20, color=:blue)
    arrows2d!(
        ax,
        xF_obs,
        yF_obs,
        u_obs,
        v_obs;
        lengthscale=0.2,
        color=:grey,
        label="Applied force",
    )
    axislegend(ax)

    lines!(ax2, t, theta_long; color=:orange, linewidth=2, linestyle=:dash)
    lines!(ax2, seis_t, seis_theta; color=:blue, linewidth=2)

    legend_entries = [
        [LineElement(; color=:blue, linewidth=2)],
        [LineElement(; color=:orange, linewidth=2, linestyle=:dash)],
    ]
    Legend(
        fig[1, 2],
        legend_entries,
        ["Full response (numerical)", "Steady-state (analytical)"];
        tellwidth=false,
        tellheight=false,
        halign=:right,
        valign=:top,
        margin=(10, 10, 10, 10),
    )

    Label(fig[0, :], "Forced Damped Pendulum"; fontsize=20, font=:bold)
    colsize!(fig.layout, 1, Relative(0.45))
    colsize!(fig.layout, 2, Relative(0.55))

    @info "Saving frames to $framedir"
    for i in eachindex(xs)
        x_obs[] = xs[i]
        y_obs[] = ys[i]
        rod_x[] = [0.0, xs[i]]
        rod_y[] = [p.L, ys[i]]
        xF_obs[] = [xF]
        yF_obs[] = [yF]
        u_obs[] = [F[i] * F_scale]
        v_obs[] = [0.0]

        t_now = t[i]
        t_max = t_now + window / 2
        t_min = t_now - window / 2
        mask = t_min .<= t[1:i] .<= t_max
        seis_t[] = t[1:i][mask]
        seis_theta[] = theta_num[1:i][mask]
        ax2.limits[] = (t_min, t_max, -seis_ylim, seis_ylim)

        time_obs[] = @sprintf("t = %05.2f s", t_now)

        save(joinpath(framedir, @sprintf("frame_%06d.png", i)), fig; px_per_unit=1)
    end

    @info "Assembling animation with ffmpeg..."
    # pass 1: generate palette
    palette = joinpath(framedir, "palette.png")
    run(
        `ffmpeg -y -framerate $fps -i $(joinpath(framedir, "frame_%06d.png")) -vf palettegen $palette`,
    )

    # pass 2: encode with palette
    run(
        `ffmpeg -y -framerate $fps -i $(joinpath(framedir, "frame_%06d.png")) -i $palette -lavfi paletteuse $savepath`,
    )

    @info "Cleaning up frames..."
    rm(framedir; recursive=true)

    return nothing
end
