module Oscillations

using OrdinaryDiffEq

export ForceField, Accelerator1D, Accelerator3D, Oscillator1D, ode_numerical, get_coord

include("oscillators.jl")
include("force_fields.jl")
include("accelerators.jl")
include("solver.jl")

end
