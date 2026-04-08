# This script builds the documentation for Springies.jl
# To run it, simply enter the project root directory and run:
#
# include("docs/make.jl")
#
# The docs will be built locally in `Springies.jl/docs/build`. To view them, open `index.html` in your browser.
#
# TODO: deploy documentation to GitHub Pages (if project becomes public).

using Documenter
using Springies

makedocs(;
    sitename="Springies.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true",
        example_size_threshold=nothing,  # Disable size warning thresholds entirely
        size_threshold_warn=nothing,
        size_threshold=nothing,
        edit_link="main",
    ),
    modules=[Springies],
    pages=[
        "Home" => "index.md",
        "Example Gallery" => "examples.md",
        "API Reference" => [
            "Types" => "api/types.md",
            "differentials!" => "api/differentials.md",
            "springy_solve" => "api/solver.md",
            "Initial conditions" => "api/init_particles.md",
        ],
    ],
)
