module Springies

using OrdinaryDiffEq
using ForwardDiff

export Pendulum1D, FreeParticle2D, BendyStalk, ThreeBody # Springy types
export ZeroForce, CosineForce, ClockForce, DoubleGyre    # External forcing types
export meshgrid_xy, init_particles, Grid, Random         # Initial condition convenience functions
export springy_solve                                     # Solver
export make_framedir, run_ffmpeg                         # Animation

include("external_forcing.jl")
include("springy_types.jl")
include("differentials.jl")
include("initial_conditions.jl")
include("solver.jl")
include("animation.jl")

# ----------------------------------------------------------------------------------------------------------
# INTERFACE NOTES
#
# - Each Springy subtype must have a corresponding differentials! method
#
# - Each ForceField subtype must have a corresponding applied_force method
# ----------------------------------------------------------------------------------------------------------

end # module
