"""
    Accelerator1D{OT<:Oscillator1D,Dim}

Type for 1D accelerators.
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

function Pendulum1D(; m::T, c::T, L::T, F::ForceField=ZeroForce(Float64), g::AbstractFloat=9.81) where {T<:AbstractFloat}
    Pendulum1D(m, c, L, T(g), F)
end