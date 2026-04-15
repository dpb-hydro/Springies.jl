# Springies.jl

**Dan Bartley, April 2026**

![Pendulum animation](animations/unforced_pendulum_dropped.gif)

## Welcome!

Welcome to `Springies.jl`! This is a personal sandbox project for having fun with dynamical systems problems. It's a wrapper for [OrdinaryDiffEq.jl](https://docs.sciml.ai/OrdinaryDiffEq/stable/). 

## Quickstart guide

Dynamical systems are encoded in `Springies.jl` using `Springy` types, which contain the system parameters and external forcing. Each `Springy` type must have a corresponding `differentials!` function, which describes how the differential terms in the system are computed.

We then solve the system with the [`springy_solve`](@ref) function.

Check out the [Example Gallery](@ref) for project ideas, and the [API Reference](@ref "System setups") for a more detailed breakdown of functionality. Have fun!