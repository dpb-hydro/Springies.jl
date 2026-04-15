# animation.jl
# Dan Bartley, April 2026
# Reusable code for assembling animations

function make_framedir(save_animation_as::String)
    framedir = joinpath(dirname(save_animation_as), "frames")
    mkpath(framedir)
    return framedir
end

# Two passes of ffmpeg: pass 1 = generate palette, pass 2 = encode with palette
function run_ffmpeg(
    framedir::String, fps::Integer, save_as::String; naming::String="frame_%06d.png"
)
    @info "Assembling animation with ffmpeg..."
    palette = joinpath(dirname(framedir), "palette.png")
    run(
        `ffmpeg -y -framerate $fps -i $(joinpath(framedir, naming)) -vf palettegen -update 1 $palette`,
    )
    run(
        `ffmpeg -y -framerate $fps -i $(joinpath(framedir, naming)) -i $palette -lavfi paletteuse $save_as`,
    )
    rm(palette)
    return nothing
end