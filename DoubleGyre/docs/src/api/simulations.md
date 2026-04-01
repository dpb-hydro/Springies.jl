```@meta
CurrentModule = DoubleGyre
CollapsedDocStrings = true
```

# Simulations

Particle simulations are done by the `advect_particles` function.

```@docs
advect_particles
```

# Helper functions

The functions below are used by [`advect_particles`](@ref) but are not intended to be called by the user.

```@docs
DoubleGyre.gyre_stream
DoubleGyre.gyre_ode!
DoubleGyre.gyre_uv
```