
struct Pendulum1D{FT} <: Oscillator1D{FT}
    m::FT
    c::FT
    L::FT
    g::FT
    mL::FT
    c_over_m::FT
    g_over_L::FT
    function Pendulum1D(m::T, c::T, L::T, g::T) where {T<:AbstractFloat}
        new{T}(m, c, L, g, m * L, c / m, g / L)
    end
end

function Pendulum1D(; m::T, c::T, L::T, g::AbstractFloat=9.81) where {T<:AbstractFloat}
    Pendulum1D(m, c, L, T(g))
end

function (a::Accelerator1D{<:Pendulum1D,Dim})(
    x::FT, dx::FT, y::FT, dy::FT, z::FT, dz::FT, t::FT
) where {FT<:AbstractFloat,Dim}
    q, dq = get_coord(Dim, x, dx, y, dy, z, dz)
    return (a.force_field(x, y, z, t) / a.oscillator.mL) - a.oscillator.c_over_m * dq -
           a.oscillator.g_over_L * sin(q)
end
