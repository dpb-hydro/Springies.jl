"""
    animate_particles(sol, G, savepath; fps, nquiver)

Create an animation of a Double Gyre simulation run.

# Arguments
- `sol`: simulation result (output from [advect_particles](@ref))
- `G`: properties of Double Gyre field
- `savepath`: name of file to save
- `fps`: frames per second
- `nquiver`: spacing control for field arrows
"""
function animate_particles(sol, G::GyreProperties, savepath::String; fps=10, nquiver=20)
    xs = [sol.u[i][1, :] for i in eachindex(sol.u)]
    ys = [sol.u[i][2, :] for i in eachindex(sol.u)]

    # Fixed coarse grid for quiver
    xq = range(0.0, 2.0; length=nquiver)
    yq = range(0.0, 1.0; length=nquiver ÷ 2)
    xgrid, ygrid = meshgrid_xy(xq, yq)

    fig = Figure(; size=(1200, 600))
    ax = Axis(
        fig[1, 1];
        xlabel="x",
        ylabel="y",
        aspect=DataAspect(),
        limits=(-0.1, 2.1, -0.1, 1.1),
    )

    # Observables for particles and quiver
    x_obs = Observable(xs[1])
    y_obs = Observable(ys[1])
    uv_obs = Observable([
        gyre_uv(G, xgrid[i, j], ygrid[i, j], sol.t[1]) for
        i in axes(xgrid, 1), j in axes(xgrid, 2)
    ])

    # Flatten quiver grid for arrows
    xq_flat = xgrid[:]
    yq_flat = ygrid[:]
    u_obs = Observable(first.(uv_obs[])[:])
    v_obs = Observable(last.(uv_obs[])[:])

    arrows2d!(ax, xq_flat, yq_flat, u_obs, v_obs; lengthscale=0.2, color=:grey)
    scatter!(ax, x_obs, y_obs; markersize=10, color=:blue)

    record(fig, savepath, eachindex(sol.u); framerate=fps, loop=0) do i
        x_obs[] = xs[i]
        y_obs[] = ys[i]
        uv = [
            gyre_uv(G, xgrid[k, l], ygrid[k, l], sol.t[i]) for
            k in axes(xgrid, 1), l in axes(xgrid, 2)
        ]
        u_obs[] = first.(uv)[:]
        v_obs[] = last.(uv)[:]
        ax.title[] = @sprintf("Double Gyre Particle Advection  t = %05.2f", sol.t[i])
    end
end
