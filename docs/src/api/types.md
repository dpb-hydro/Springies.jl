```@meta
CurrentModule = Springies
CollapsedDocStrings = false
```

# Types

`Springies.jl` defines two abstract supertypes; **`Springy`** and **`ForceField`**.

## Springy

`Springy` objects contain the parameters and external forcing of a dynamical system. The external forcing is contained in a `ForceField` object.

```@docs
Springy
```   

These are the concrete subtypes of `Springy` currently defined in `Springies.jl`:

```@docs
Pendulum1D
```     

## ForceField

`ForceField` objects contain the external forcing of a dynamical system. They are passed to `Springy` objects.

```@docs
ForceField
```

These are the concrete subtypes of `ForceField` currently defined in `Springies.jl`:

```@docs
ZeroForce
CosineForce
ClockForce
``` 