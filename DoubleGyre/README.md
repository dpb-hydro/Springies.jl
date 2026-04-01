# DoubleGyre.jl
#### Dan Bartley, March 2026

[![Build Status](https://github.com/dpb-hydro/DoubleGyre.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/dpb-hydro/DoubleGyre.jl/actions/workflows/CI.yml?query=branch%3Amain)

A project for having fun with the Double Gyre canonical problem in dynamical systems.

## How to get started

1. Clone this repo to your computer.
2. Enter the cloned repo on your computer:

```bash
cd /path/to/DoubleGyre.jl
```

3. Instantiate the main project environment:

```julia
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

and also the `docs` environment:

```julia
julia --project=docs -e 'using Pkg; Pkg.instantiate()'
```

5. Build the documentation:

```julia
julia --project=docs/ docs/make.jl
```

6. Open the documentation by opening `./docs/build/index.html` with your browser.

Everything you need to know about using `DoubleGyre.jl` can be found in the documentation. Have fun!