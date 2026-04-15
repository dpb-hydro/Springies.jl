using Springies
using Test
using Aqua

@testset "Springies.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Springies; persistent_tasks=false)
    end

    @testset "Unforced pendulum decays to zero" begin
        pendulum = Pendulum1D(10.0, 0.7, 5.0)
        tspan = (0.0, 1000.0)
        u0 = [0.0, 0.5]
        Nt = 10
        u_solved = springy_solve(pendulum, tspan, u0, Nt)
        θ_final = u_solved[1, :][end]
        dθ_final = u_solved[1, :][end]
        @test abs(θ_final) < 1e-4
        @test abs(dθ_final) < 1e-4
    end

    @testset "DoubleGyre" begin
        @testset "Basic regular initial conditions" begin
            nx = 5
            xc = 0.0
            Ax = 1.0

            ny = 5
            yc = 0.0
            Ay = 1.0

            particles = init_particles(nx, ny, xc, yc, Ax, Ay, Grid())

            r1 = repeat(range(-0.5, 0.5; length=5); inner=5)
            r2 = repeat(reverse(range(-0.5, 0.5; length=5)); outer=5)
            r = permutedims(hcat(r1, r2))

            @test all(particles .== permutedims(hcat(r1, r2)))
        end
    end
end
