module Springies

using OrdinaryDiffEq

export Pendulum1D                         # Springy types
export ZeroForce, CosineForce, ClockForce # External forcing types
export meshgrid_xy, init_particles        # Initial condition convenience functions
export springy_solve                      # Solver

include("abstract_types.jl")
include("external_forcing.jl")
include("springy_types.jl")
include("differentials.jl")
include("initial_conditions.jl")
include("solver.jl")

# ----------------------------------------------------------------------------------------------------------
# Each new type NewSpringy{FT} <: Springy{FT} must implement
# function differentials!(du::Vector{FT}, u::Vector{FT}, p::NewSpringy{FT}, t::FT) where {FT<:AbstractFloat}
# in file differentials.jl
# ----------------------------------------------------------------------------------------------------------

end # module