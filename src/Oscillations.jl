module Oscillations

using OrdinaryDiffEq

include("types.jl")
include("oscillators.jl")
include("force_fields.jl")
include("solver.jl")

end

using .Oscillations
osc = Oscillations
