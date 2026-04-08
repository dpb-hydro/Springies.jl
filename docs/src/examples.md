```@meta
CurrentModule = Springies
CollapsedDocStrings = true
```

# Example Gallery

## Unforced pendulums

We can launch a pendulum by dropping it from rest:

![Dropped pendulum animation](animations/unforced_pendulum_dropped.gif)

And we can also launch it with a nonzero initial velocity:

![Launched pendulum animation](animations/unforced_pendulum_launched.gif)

## Forced pendulums

If we apply a periodic forcing to the pendulum, it eventually reaches a steady state controlled by that forcing. This steady state can be found through nondimensionalisation:

![Forced pendulum animation](animations/forced_pendulum.gif)

We can also do a basic simulation of a clock:

![Forced pendulum animation](animations/clock_pendulum.gif)

## The Double Gyre

We can use `Springies.jl` to play with advection in the canonical Double Gyre problem:

![Double Gyre advection](animations/double_gyre.gif)

What if, instead of a velocity field, we were to think of the Double Gyre over a field of grass? Let's model the grass blades as flexible beams; we'll decouple the x and y components so that we can think of two springs, one in the x and the other in the y direction:

![Double Gyre springs](animations/grassy_gyre.gif)

## The Three-body problem

Here is an example of the three-body problem in 2D:

![Three-body problem](animations/three_body_short.gif)

If we run the simulation for longer, we can see the formation of a bound pair and the ejection of the third body. This is sometimes called the "Heggie-Hills law" (or the statistical escape hypothesis): 

![Three-body problem](animations/three_body_long.gif)