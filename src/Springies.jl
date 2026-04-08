module Springies

using OrdinaryDiffEq
using ForwardDiff

export Pendulum1D, FreeParticle2D, BendyStalk         # Springy types
export ZeroForce, CosineForce, ClockForce, DoubleGyre # External forcing types
export meshgrid_xy, init_particles                    # Initial condition convenience functions
export springy_solve                                  # Solver

include("abstract_types.jl")
include("external_forcing.jl")
include("springy_types.jl")
include("differentials.jl")
include("initial_conditions.jl")
include("solver.jl")

# ----------------------------------------------------------------------------------------------------------
# INTERFACE NOTES
#
# - Each Springy subtype must define differentials!(du, u, p::MySpringy{FT}, t) in differentials.jl
#
# - Each ForceField subtype must implement (f::MyForce{FT})(x, y, z, t) in external_forcing.jl
# ----------------------------------------------------------------------------------------------------------

end # module
