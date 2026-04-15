```@meta
CurrentModule = Springies
CollapsedDocStrings = false
```

# Animation

In `Springies.jl`, you are limited only by your imagination. Since the resulting simulations differ widely in form, `Springies.jl` does not provide its own plotting routines, and it's up to you to decide how to do this. When simulations are large, one option is to save individual frames to disk and then assemble them into an animation using `ffmpeg`. For convenience, the two functions below are provided to minimise the need for boilerplate code when doing this:

```@docs
make_framedir
run_ffmpeg
```