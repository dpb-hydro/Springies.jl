module Oscillations

using OrdinaryDiffEq

export ForceField, Accelerator1D, Accelerator3D, Oscillator1D, ode_numerical, get_coord

include("types.jl")
include("solver.jl")

end
