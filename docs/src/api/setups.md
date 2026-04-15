```@meta
CurrentModule = Springies
CollapsedDocStrings = false
```

# System setups

This page shows how dynamical systems are encoded in `Springies.jl`, and shows the existing setups provided.

## Overview

Dynamical systems are encoded in `Springies.jl` using `Springy` types, which contain the system parameters and external forcing. Each `Springy` type must have a corresponding `differentials!` function, which describes how the differential terms in the system are computed.

## Pendulums

We encode a pendulum as:

```@docs
Pendulum1D
``` 

The following external forcings are available for use on a pendulum:

```@docs
ZeroForce
CosineForce
ClockForce
```

## The Double Gyre

Double Gyre problems use the Double Gyre field:

```@docs
DoubleGyre
``` 

Two setups are currently available for use in this field:

```@docs
FreeParticle2D
BendyStalk
```

## The Three-body Problem

We encode the Three-body problem using this type:

```@docs
ThreeBody
```