using Oscillations
using Test
using Aqua

@testset "Oscillations.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Oscillations)
    end
    # Write your tests here.
end
