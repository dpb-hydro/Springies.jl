using Springies
using Test
using Aqua

@testset "Springies.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Springies; persistent_tasks=false)
    end

    @testset "Unforced pendulum decays to zero" begin
        pendulum = Pendulum1D(m=10.0, c=0.7, L=5.0)
        tspan = (0.0, 1000.0)
        u0 = [0.0, 0.5]
        Nt = 10
        u_solved = springy_solve(pendulum, tspan, u0, Nt)
        θ_final = u_solved[end][1]
        dθ_final = u_solved[end][2]
        @test abs(θ_final) < 1e-4
        @test abs(dθ_final) < 1e-4
    end
end
