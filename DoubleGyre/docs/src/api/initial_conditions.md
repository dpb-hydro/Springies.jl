```@meta
CurrentModule = DoubleGyre
CollapsedDocStrings = true
```

# Initial conditions

Initial particle positions are set using the `init_particles` function, which can set particles either in a regular or random arrangement.

```@docs
init_particles
```

# Helper functions

The functions below are used by [`init_particles`](@ref) but are not intended to be called by the user.

```@docs
DoubleGyre.meshgrid_xy
DoubleGyre.unit_grid
DoubleGyre.flatten
DoubleGyre.shift_scale
```