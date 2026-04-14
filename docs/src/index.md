# Springies.jl

**Dan Bartley, April 2026**

![Pendulum animation](animations/unforced_pendulum_dropped.gif)

## Welcome!

Welcome to `Springies.jl`! This is a personal sandbox project for having fun with dynamical systems problems. It's a wrapper for [OrdinaryDiffEq.jl](https://docs.sciml.ai/OrdinaryDiffEq/stable/). 

## Quickstart guide

In `Springies.jl`, we encode dynamical system setups using two core constructs:
 
* [`Springy`](@ref Springies.Springy) structs, containing system parameters and external forcing,
* [`differentials!`](@ref Springies.differentials!) functions, describing how differential terms are computed.

We then solve the system with the [`springy_solve`](@ref) function.

Check out the [Example Gallery](@ref) for project ideas, and the [API Reference](@ref "Types") for a more detailed breakdown of functionality. Have fun!