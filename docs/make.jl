# This script builds the documentation for Springies.jl
# To run it locally, simply enter the project root directory and run:
#
# include("docs/make.jl")
#
# The docs will be built locally in `Springies.jl/docs/build`. To view them, open `index.html` in your browser.

using Documenter
using Springies

makedocs(;
    sitename="Springies.jl",
    checkdocs=:exports,
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
            "System setups" => "api/setups.md",
            "Differential terms" => "api/differentials.md",
            "External forcing" => "api/forcing.md",
            "Initial conditions" => "api/init_particles.md",
            "Solver" => "api/solver.md",
            "Animation" => "api/animation.md",
        ],
    ],
)

deploydocs(; repo="github.com/dpb-hydro/Springies.jl.git")
