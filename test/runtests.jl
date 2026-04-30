using Springies
using Test
using Aqua
using JET

# Defined at file scope to avoid redefining on re-runs
struct TestSpringy{FT} <: Springies.Springy{FT} end

@testset "Springies.jl" begin

    # ------------------------------------------------------------------
    # Code quality
    # ------------------------------------------------------------------

    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Springies; persistent_tasks=false)
    end

    @testset "JET static analysis" begin
        JET.test_package(Springies; target_modules=(Springies,))
    end

    # ------------------------------------------------------------------
    # Types
    # ------------------------------------------------------------------

    @testset "Types" begin
        @testset "Pendulum1D precomputed values" begin
            p = Pendulum1D(2.0, 0.5, 4.0)
            @test p.mL ≈ 8.0
            @test p.c_over_m ≈ 0.25
            @test p.g_over_L ≈ 9.81 / 4.0
        end

        @testset "Pendulum1D keyword defaults" begin
            p = Pendulum1D(1.0, 0.1, 1.0)
            @test p.g ≈ 9.81
            @test p.F isa ZeroForce
        end

        @testset "BendyStalk precomputed values" begin
            f = ZeroForce(Float64)
            s = BendyStalk(2.0, 0.4, 8.0, 0.1, 0.2, f)
            @test s.c_over_m ≈ 0.2
            @test s.k_over_m ≈ 4.0
        end

        @testset "Float32 support" begin
            p = Pendulum1D(1.0f0, 0.1f0, 1.0f0)
            @test p isa Pendulum1D{Float32}
            @test p.mL isa Float32
        end
    end

    # ------------------------------------------------------------------
    # External forcing
    # ------------------------------------------------------------------

    @testset "External Forcing" begin
        @testset "ZeroForce" begin
            f = ZeroForce(Float64)
            @test Springies.applied_force(f, 0.0, 0.0, 0.0) == 0.0
            @test Springies.applied_force(f, 1.5, -2.3, 100.0) == 0.0
        end

        @testset "CosineForce" begin
            f = CosineForce(2.0, Float64(π))
            @test Springies.applied_force(f, 0.0, 0.0, 0.0) ≈ 2.0       # F0 * cos(0) = F0
            @test Springies.applied_force(f, 0.0, 0.0, 1.0) ≈ -2.0      # F0 * cos(π) = -F0
            @test Springies.applied_force(f, 5.0, -3.0, 0.0) ≈ 2.0      # independent of position
        end

        @testset "ClockForce" begin
            f = ClockForce(1.0, 0.5)
            @test Springies.applied_force(f, 0.6, 0.1, 0.0) ≈ 1.0       # outward, past threshold
            @test Springies.applied_force(f, -0.6, -0.1, 0.0) ≈ -1.0    # outward, negative direction
            @test Springies.applied_force(f, 0.5, 0.1, 0.0) ≈ 1.0       # exactly at threshold (>=)
            @test Springies.applied_force(f, 0.3, 0.1, 0.0) == 0.0      # below threshold
            @test Springies.applied_force(f, 0.6, -0.1, 0.0) == 0.0     # past threshold but moving inward
        end

        @testset "DoubleGyre" begin
            g = DoubleGyre(0.1, 0.25, Float64(2π))

            @test Springies.applied_force(g, 0.5, 0.5, 0.0) isa Tuple{Float64,Float64}

            # No normal flow through domain boundaries
            _, v_bottom = Springies.applied_force(g, 0.5, 0.0, 0.0)
            _, v_top = Springies.applied_force(g, 0.5, 1.0, 0.0)
            u_left, _ = Springies.applied_force(g, 0.0, 0.5, 0.0)
            u_right, _ = Springies.applied_force(g, 2.0, 0.5, 0.0)
            @test abs(v_bottom) < 1e-10
            @test abs(v_top) < 1e-10
            @test abs(u_left) < 1e-10
            @test abs(u_right) < 1e-10

            # Incompressibility: ∇·v ≈ 0 (guaranteed by stream-function construction)
            x, y, t = 0.7, 0.4, 1.0
            h = 1e-7
            u_xp, _ = Springies.applied_force(g, x + h, y, t)
            u_xm, _ = Springies.applied_force(g, x - h, y, t)
            _, v_yp = Springies.applied_force(g, x, y + h, t)
            _, v_ym = Springies.applied_force(g, x, y - h, t)
            divergence = (u_xp - u_xm) / (2h) + (v_yp - v_ym) / (2h)
            @test abs(divergence) < 1e-5
        end
    end

    # ------------------------------------------------------------------
    # Differentials
    # ------------------------------------------------------------------

    @testset "Differentials" begin
        @testset "Pendulum1D" begin
            du = zeros(2)
            p = Pendulum1D(1.0, 0.0, 1.0)  # no damping, no forcing

            Springies.differentials!(du, [0.0, 0.0], p, 0.0)
            @test du ≈ zeros(2)                     # at rest at origin: no dynamics

            Springies.differentials!(du, [0.0, 1.0], p, 0.0)
            @test du[1] ≈ 1.0                       # angular velocity propagates to angle

            θ = 0.3
            Springies.differentials!(du, [θ, 0.0], p, 0.0)
            @test du[2] ≈ -9.81 * sin(θ)            # gravity restores from displacement

            p_damped = Pendulum1D(1.0, 2.0, 1.0)
            Springies.differentials!(du, [0.0, 1.0], p_damped, 0.0)
            @test du[2] ≈ -2.0                       # damping -(c/m)*dθ at θ=0

            F = CosineForce(2.0, 1.0)
            p_forced = Pendulum1D(1.0, 0.0, 1.0; F=F)
            Springies.differentials!(du, [0.0, 0.0], p_forced, 0.0)
            @test du[2] ≈ 2.0                        # F0/(m*L) at t=0
        end

        @testset "FreeParticle2D" begin
            g = DoubleGyre(0.1, 0.0, Float64(2π))
            p = FreeParticle2D{Float64,typeof(g)}(g)
            du = zeros(2)
            x, y, t = 0.5, 0.3, 0.0
            Springies.differentials!(du, [x, y], p, t)
            u_expected, v_expected = Springies.applied_force(g, x, y, t)
            @test du[1] ≈ u_expected
            @test du[2] ≈ v_expected
        end

        @testset "BendyStalk" begin
            f = DoubleGyre(0.0, 0.0, 1.0)  # A=0 → zero velocity field everywhere
            x0, y0 = 0.3, 0.4
            p = BendyStalk(1.0, 0.5, 2.0, x0, y0, f)
            du = zeros(4)

            Springies.differentials!(du, [x0, 0.0, y0, 0.0], p, 0.0)
            @test du ≈ zeros(4)                      # neutral position, no velocity: no dynamics

            dx = 0.2
            Springies.differentials!(du, [x0 + dx, 0.0, y0, 0.0], p, 0.0)
            @test du[2] ≈ -2.0 * dx                  # spring restoring: -(k/m) * displacement
            @test du[4] ≈ 0.0                         # y unaffected

            Springies.differentials!(du, [x0, 1.0, y0, 0.0], p, 0.0)
            @test du[2] ≈ -0.5                        # damping: -(c/m) * velocity
        end

        @testset "ThreeBody" begin
            p = ThreeBody(1.0, 1.0, 1.0, 1.0)
            du = zeros(12)
            # Body 3 at midpoint between bodies 1 and 2: symmetric forces cancel
            u = [0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]
            Springies.differentials!(du, u, p, 0.0)
            @test du[11] ≈ 0.0 atol=1e-10            # zero net x-force on body 3 by symmetry
            @test du[12] ≈ 0.0 atol=1e-10            # zero net y-force on body 3 by symmetry
            # Symmetric config → equal and opposite total accelerations on bodies 1 and 2
            @test du[3] ≈ -du[7] atol=1e-10
            @test du[4] ≈ -du[8] atol=1e-10
        end

        @testset "Fallback throws for undefined Springy" begin
            p = TestSpringy{Float64}()
            @test_throws ArgumentError Springies.differentials!(zeros(1), zeros(1), p, 0.0)
        end
    end

    # ------------------------------------------------------------------
    # Initial conditions
    # ------------------------------------------------------------------

    @testset "Initial Conditions" begin
        @testset "meshgrid_xy" begin
            x = [1.0, 2.0, 3.0]
            y = [4.0, 5.0]
            xg, yg = meshgrid_xy(x, y)
            @test size(xg) == (2, 3)
            @test xg[1, :] == [1.0, 2.0, 3.0]  # x progresses right along columns
            @test yg[:, 1] == [5.0, 4.0]        # y progresses upward (reversed along rows)
        end

        @testset "init_particles (Grid) shape and range" begin
            particles = init_particles(5, 4, 0.0, 0.0, 1.0, 1.0, Grid())
            @test size(particles) == (2, 20)
            @test minimum(particles[1, :]) ≈ -0.5
            @test maximum(particles[1, :]) ≈ 0.5
            @test minimum(particles[2, :]) ≈ -0.5
            @test maximum(particles[2, :]) ≈ 0.5
        end

        @testset "init_particles (Grid) centre and extent" begin
            cx, cy, Ax, Ay = 1.5, 2.5, 3.0, 4.0
            particles = init_particles(5, 5, cx, cy, Ax, Ay, Grid())
            @test minimum(particles[1, :]) ≈ cx - Ax / 2
            @test maximum(particles[1, :]) ≈ cx + Ax / 2
            @test minimum(particles[2, :]) ≈ cy - Ay / 2
            @test maximum(particles[2, :]) ≈ cy + Ay / 2
        end

        @testset "init_particles (Grid) exact coordinates" begin
            nx, ny = 5, 5
            particles = init_particles(nx, ny, 0.0, 0.0, 1.0, 1.0, Grid())
            r1 = repeat(range(-0.5, 0.5; length=nx); inner=ny)
            r2 = repeat(reverse(range(-0.5, 0.5; length=ny)); outer=nx)
            @test all(particles .== permutedims(hcat(r1, r2)))
        end

        @testset "init_particles (Random) shape and range" begin
            particles = init_particles(10, 0.0, 0.0, 1.0, 1.0, Random())
            @test size(particles) == (2, 10)
            @test all(-0.5 .≤ particles[1, :] .≤ 0.5)
            @test all(-0.5 .≤ particles[2, :] .≤ 0.5)
        end

        @testset "Input validation" begin
            @test_throws ArgumentError init_particles(1, 5, 0.0, 0.0, 1.0, 1.0, Grid())
            @test_throws ArgumentError init_particles(5, 1, 0.0, 0.0, 1.0, 1.0, Grid())
            @test_throws ArgumentError Springies.unit_grid(0, 5, Random())
        end
    end

    # ------------------------------------------------------------------
    # Solver
    # ------------------------------------------------------------------

    @testset "Solver" begin
        @testset "Unforced pendulum decays to zero" begin
            pendulum = Pendulum1D(10.0, 0.7, 5.0)
            tspan = (0.0, 1000.0)
            u0 = [0.0, 0.5]
            Nt = 10
            u_solved = springy_solve(pendulum, tspan, u0, Nt)
            θ_final = u_solved[1, :][end]
            dθ_final = u_solved[2, :][end]
            @test abs(θ_final) < 1e-4
            @test abs(dθ_final) < 1e-4
        end

        @testset "Output dimensions" begin
            p1 = Pendulum1D(1.0, 0.1, 1.0)
            @test size(springy_solve(p1, (0.0, 1.0), [0.1, 0.0], 10)) == (2, 10)

            f2 = DoubleGyre(0.0, 0.0, 1.0)  # A=0 → zero velocity field
            p2 = BendyStalk(1.0, 0.1, 1.0, 0.0, 0.0, f2)
            @test size(springy_solve(p2, (0.0, 1.0), [0.1, 0.0, 0.0, 0.0], 10)) == (4, 10)

            p3 = ThreeBody(1.0, 1.0, 1.0, 0.01)
            u0_tb = [0.0, 3.0, 0.0, 0.0, -2.0, -1.5, 0.0, 0.0, 2.0, -1.5, 0.0, 0.0]
            @test size(springy_solve(p3, (0.0, 1.0), u0_tb, 10)) == (12, 10)
        end

        @testset "BendyStalk at equilibrium stays at equilibrium" begin
            f = DoubleGyre(0.0, 0.0, 1.0)  # A=0 → zero velocity field
            x0, y0 = 0.3, 0.7
            s = BendyStalk(1.0, 0.0, 1.0, x0, y0, f)
            sol = springy_solve(s, (0.0, 10.0), [x0, 0.0, y0, 0.0], 20)
            @test all(isapprox.(sol[1, :], x0; atol=1e-8))
            @test all(isapprox.(sol[2, :], 0.0; atol=1e-8))
            @test all(isapprox.(sol[3, :], y0; atol=1e-8))
            @test all(isapprox.(sol[4, :], 0.0; atol=1e-8))
        end

        @testset "ThreeBody centre of mass conservation" begin
            # No external forces → total momentum conserved → CoM fixed
            p = ThreeBody(1.0, 1.0, 1.0, 0.01)
            u0 = [0.0, 3.0, 0.1, 0.2, -2.0, -1.5, -0.05, 0.0, 2.0, -1.5, -0.05, -0.2]
            sol = springy_solve(p, (0.0, 5.0), u0, 20)
            com_x0 = (u0[1] + u0[5] + u0[9]) / 3
            com_y0 = (u0[2] + u0[6] + u0[10]) / 3
            for i in 1:20
                @test (sol[1, i] + sol[5, i] + sol[9, i]) / 3 ≈ com_x0 atol=1e-6
                @test (sol[2, i] + sol[6, i] + sol[10, i]) / 3 ≈ com_y0 atol=1e-6
            end
        end
    end
end
