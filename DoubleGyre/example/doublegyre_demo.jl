using DoubleGyre

## Settings

# Gyre properties
A = 0.1  # Magnitude control
ϵ = 0.25 # Wobble size control
T = 10.0 # Wobble period

# Initial conditions in x
nx = 15   # Number
xc = 0.5  # Centre
Ax = 0.1  # Extent

# Initial conditions in y
ny = 15   # Number
yc = 0.75 # Centre
Ay = 0.1  # Extent

# Initialisation method
method = :regular # [:regular/:rand]

# Time range
tspan = (0.0, 5.0*T)

## ========================================================================

## Simulation

G = GyreProperties(A, ϵ, 2*π/T)
xy0 = init_particles(nx, ny, xc, yc, Ax, Ay; method=method)
sol = advect_particles(xy0, G, tspan)
animate_particles(sol, G, joinpath(@__DIR__, "double_gyre.gif"))
