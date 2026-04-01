module Oscillations

using OrdinaryDiffEq

include("types.jl")
include("solver.jl")

end

using .Oscillations
osc = Oscillations
