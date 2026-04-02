module Springy

using OrdinaryDiffEq

export Oscillator1D
export ForceField
export Accelerator1D, Accelerator3D, get_coord
export ode_numerical
export meshgrid_xy, init_particles

include("oscillators.jl")
include("force_fields.jl")
include("accelerators.jl")
include("solver.jl")
include("initial_conditions.jl")

end
