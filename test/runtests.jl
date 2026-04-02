using Springy
using Test
using Aqua

@testset "Springy.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Springy)
    end
    # Write your tests here.
end
