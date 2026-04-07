# Springies.jl


**Dan Bartley, April 2026**

![Pendulum animation](hero_image.gif)

## Welcome!

Welcome to `Springies.jl`! This project is a sandbox for having fun with dynamical systems problems. It's a wrapper for [OrdinaryDiffEq.jl](https://docs.sciml.ai/OrdinaryDiffEq/stable/). 

## Quickstart guide

In `Springies.jl`, we encode dynamical system setups in two objects:
 
* [`Springy`](@ref Springies.Springy) objects, containing system parameters and external forcing,
* [`differentials!`](@ref Springies.differentials!) functions, describing how differential values are computed.

We can then solve the system with the [`springy_solve`](@ref) function.

Check out the [Example Gallery](@ref) for project ideas, and the [API Reference](@ref "Abstract Types") for a more detailed breakdown of functionality. Have fun!