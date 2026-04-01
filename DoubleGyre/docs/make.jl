# This script builds the documentation for ToyLand.jl
# To run it, simply enter the project root directory and run:
#
# include("docs/make.jl")
#
# The docs will be built locally in `ToyLand.jl/docs/build`. To view them, open `index.html` in your browser.
#
# TODO: deploy documentation to GitHub Pages (if project becomes public).

using Documenter
using DoubleGyre

makedocs(;
    sitename="DoubleGyre.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true",
        example_size_threshold=nothing,  # Disable size warning thresholds entirely
        size_threshold_warn=nothing,
        size_threshold=nothing,
        edit_link="main",
    ),
    modules=[DoubleGyre],
    pages=[
        "Home" => "index.md",
        "API reference" => [
            "Types" => "api/types.md",
            "Initial conditions" => "api/initial_conditions.md",
            "Simulations" => "api/simulations.md",
            "Animations" => "api/animation.md",
        ],
        "References" => "references.md",
    ],
)
