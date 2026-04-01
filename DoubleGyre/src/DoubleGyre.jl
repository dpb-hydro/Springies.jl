module DoubleGyre

using CairoMakie
using ForwardDiff
using OrdinaryDiffEq
using Printf

export GyreProperties
export init_particles
export advect_particles
export animate_particles

include("types.jl")
include("initial_conditions.jl")
include("velocity.jl")
include("solver.jl")
include("animation.jl")

end
