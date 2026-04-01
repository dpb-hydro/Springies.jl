using DoubleGyre
using Test

@testset "DoubleGyre" begin
    @testset "Initial conditions" begin
        @testset "Basic test regular" begin
            nx = 5
            xc = 0.0
            Ax = 1.0

            ny = 5
            yc = 0.0
            Ay = 1.0

            method = :regular

            particles = init_particles(nx, ny, xc, yc, Ax, Ay, method=method)

            r1 = repeat(range(-0.5, 0.5, length=5), inner=5)
            r2 = repeat(reverse(range(-0.5, 0.5, length=5)), outer=5)
            r = permutedims(hcat(r1, r2))

            @test all(particles .== permutedims(hcat(r1, r2)))
        end
    end
end
