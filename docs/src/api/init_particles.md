```@meta
CurrentModule = Springies
CollapsedDocStrings = false
```

# Initial Conditions

`Springies.jl` defines some convenience functions for creating initial conditions. 

```@docs
meshgrid_xy
init_particles
```

## Helper functions

The functions below are used internally by `meshgrid_xy` and `init_particles` but not exported.

```@docs
shift_scale
unit_grid
flatten
```   