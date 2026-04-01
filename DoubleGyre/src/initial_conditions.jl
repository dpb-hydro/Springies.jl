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
    shift_scale(collection, x0, A)

Move a collection of points to a new origin `x0` and scale by `A`.
"""
function shift_scale(collection::AbstractArray, x0::Real, A::Real)
    return x0 .+ A .* collection
end

"""
    unit_grids(nx, ny, method)

Create two coordinate grids of size (`ny`, `nx`) where elements are between -0.5 and 0.5.

Generation method can either be `:regular` or `:rand`.
"""
function unit_grid(nx::Integer, ny::Integer; method)
    (nx > 0 && ny > 0) ||
        throw(ArgumentError("nx and ny must be greater than zero, got $nx and $ny"))

    if method == :regular
        xi = range(-0.5, 0.5; length=nx)
        yi = range(-0.5, 0.5; length=ny)
        return meshgrid_xy(xi, yi)
    elseif method == :rand
        x = rand(ny, nx) .- 0.5
        y = rand(ny, nx) .- 0.5
        return x, y
    else
        throw(ArgumentError("method must be :regular or :rand, got :$method"))
    end
end

"""
    flatten(xgrid, ygrid)

Create a `(2, N)` array of particle coordinates, with `x` on the first row and `y` on the second.
"""
function flatten(xgrid::AbstractArray, ygrid::AbstractArray)
    return permutedims(hcat(xgrid[:], ygrid[:]))
end

"""
    init_particles(nx, ny, cx, cy, Ax, Ay; method)

Initialise particle positions either as a regular grid or random placement.

# Arguments
- `nx`: number of particles along x dimension
- `ny`: number of particles along y dimension
- `cx`: x-coordinate centre of particle cluster
- `cy`: y-coordinate centre of particle cluster
- `Ax`: extent of particle cluster along x dimension
- `Ay`: extent of particle cluster along x dimension
- `method`: `:regular` for grid, `:rand` for random

# Note
For the case `method=:rand`, `nx` and `ny` are not meaningful as numbers of points along grid dimensions, but instead the number of particles is controlled by `nx`*`ny`.
"""
function init_particles(
    nx::Integer, ny::Integer, cx::Real, cy::Real, Ax::Real, Ay::Real; method
)
    x_grid, y_grid = unit_grid(nx, ny; method=method)
    x, y = shift_scale(x_grid, cx, Ax), shift_scale(y_grid, cy, Ay)
    return flatten(x, y)
end
