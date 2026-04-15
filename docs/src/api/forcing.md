```@meta
CurrentModule = Springies
CollapsedDocStrings = false
```

# External forcing

Every `ForceField` type must have a corresponding `applied_force` function method which describes how the value of applied force at given coordinates. These are the `aplied_force` methods currently defined in `Springies.jl`:

```@docs
applied_force
```     