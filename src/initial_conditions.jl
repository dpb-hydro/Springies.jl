# initial_conditions.jl
# Dan Bartley, April 2026
# Convenience functions for specifying initial conditions.

"""
    InitialisationMethod

Initialisation method for init_particles. Can either be `Grid()` or `Random()`.
"""
abstract type InitialisationMethod end
struct Grid <: InitialisationMethod end
struct Random <: InitialisationMethod end

"""
    meshgrid_xy(x, y)

Create grids from coordinates `x` and `y`. 

`x` progresses to the right along the second dimension, and `y` progresses upwards along the first dimension.
"""
function meshgrid_xy(x::AbstractVector, y::AbstractVector)
    x_grid = [xi for _ in y, xi in x]
    y_grid = [yi for yi in reverse(y), _ in x]
    return x_grid, y_grid
end

"""
    init_particles(nx, ny, cx, cy, Ax, Ay; m:InitialisationMethod)

Initialise particle positions either as a regular grid or random placement.

# Arguments
- `nx`: number of particles along x dimension
- `ny`: number of particles along y dimension
- `cx`: x-coordinate centre of particle cluster
- `cy`: y-coordinate centre of particle cluster
- `Ax`: extent of particle cluster along x dimension
- `Ay`: extent of particle cluster along y dimension
- `m`: `Grid()` for grid, `Random()` for random placement
"""
function init_particles(
    nx::Integer,
    ny::Integer,
    cx::Real,
    cy::Real,
    Ax::Real,
    Ay::Real,
    m::InitialisationMethod,
)
    x_grid, y_grid = unit_grid(nx, ny, m)
    x_shifted, y_shifted = shift_scale(x_grid, cx, Ax), shift_scale(y_grid, cy, Ay)
    xy_flat = flatten(x_shifted, y_shifted)
    return xy_flat
end

"""
    init_particles(n, cx, cy, Ax, Ay m::Random)

Convenience method for placing random particles, providing total number of particles `n` rather than particles in x and y directions.
"""
function init_particles(n::Integer, cx::Real, cy::Real, Ax::Real, Ay::Real, m::Random)
    return init_particles(n, 1, cx, cy, Ax, Ay, m)
end

# ----------------------------------------------------------------------------------------------------------
# HELPER FUNCTIONS
# ----------------------------------------------------------------------------------------------------------

"""
    shift_scale(collection, x0, A)

Move a collection of points to a new origin `x0` and scale by `A`.
"""
function shift_scale(collection::Array, x0::Real, A::Real)
    return x0 .+ A .* collection
end

"""
    flatten(xgrid, ygrid)

Create a `(2, N)` array of particle coordinates, with `x` on the first row and `y` on the second.
"""
function flatten(xgrid::AbstractArray, ygrid::AbstractArray)
    return permutedims(hcat(xgrid[:], ygrid[:]))
end

"""
    unit_grid(nx, ny, ::Grid)

Create two regular coordinate grids of size (`ny`, `nx`) where elements are between -0.5 and 0.5.
"""
function unit_grid(nx::Integer, ny::Integer, ::Grid)
    (nx > 1 && ny > 1) ||
        throw(ArgumentError("nx and ny must be greater than one, got $nx and $ny"))
    xi = range(-0.5, 0.5; length=nx)
    yi = range(-0.5, 0.5; length=ny)
    xy = meshgrid_xy(xi, yi)
    return xy
end

"""
    unit_grid(nx, ny, ::Grid)

Create two random coordinate grids of size (`ny`, `nx`) where elements are between -0.5 and 0.5.
"""
function unit_grid(nx::Integer, ny::Integer, ::Random)
    (nx > 0 && ny > 0) ||
        throw(ArgumentError("nx and ny must be greater than zero, got $nx and $ny"))
    xi = rand(ny, nx) .- 0.5
    yi = rand(ny, nx) .- 0.5
    xy = xi, yi
    return xy
end
