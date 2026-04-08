# Springy [![Build Status](https://github.com/dpb-hydro/Springy.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/dpb-hydro/Springy.jl/actions/workflows/CI.yml?query=branch%3Amain) [![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

Welcome to `Springies.jl`! This project is a sandbox for having fun with dynamical systems problems. It's a wrapper for [OrdinaryDiffEq.jl](https://docs.sciml.ai/OrdinaryDiffEq/stable/). 

## How to get started

1. Clone this repo to your computer.
2. Enter the cloned repo on your computer:

```bash
cd /path/to/Springies.jl
```

3. Instantiate the main project environment:

```julia
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

5. Build the documentation (you will need `Documenter.jl` available):

```julia
julia --project=. docs/make.jl
```

6. Open the documentation by opening `./docs/build/index.html` with your browser.

Everything you need to know about using `Springies.jl` can be found in the documentation. Have fun!