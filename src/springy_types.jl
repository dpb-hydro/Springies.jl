"""
    Pendulum1D{FT<:AbstractFloat} <: Springy{FT}

A damped, driven pendulum in 1D.

# Fields
- `m`: Mass
- `c`: Damping coefficient
- `L`: Pendulum length
- `g`: Gravitational acceleration
- `F`: External force field
- `mL`: Precomputed `m * L`
- `c_over_m`: Precomputed `c / m`
- `g_over_L`: Precomputed `g / L`
"""
struct Pendulum1D{FT} <: Springy{FT}
    m::FT
    c::FT
    L::FT
    g::FT
    F::ForceField{FT}
    mL::FT
    c_over_m::FT
    g_over_L::FT
    function Pendulum1D(m::T, c::T, L::T, g::T, F::ForceField{T}) where {T<:AbstractFloat}
        new{T}(m, c, L, g, F, m * L, c / m, g / L)
    end
end

"""
    Pendulum1D(; m, c, L, F=nothing, g=9.81)

Keyword constructor for `Pendulum1D`. Defaults to `g = 9.81` and zero external forcing.
"""
function Pendulum1D(;
    m::T, c::T, L::T, F::Union{ForceField{T},Nothing}=nothing, g::AbstractFloat=9.81
) where {T<:AbstractFloat}
    Pendulum1D(m, c, L, T(g), isnothing(F) ? ZeroForce(T) : F)
end
