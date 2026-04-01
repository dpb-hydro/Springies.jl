@inline function _get_coord(dim::Symbol, x, dx, y, dy, z, dz)
    dim === :x && return x, dx
    dim === :y && return y, dy
    dim === :z && return z, dz
    throw(ArgumentError("Unknown dimension: $dim"))
end

"""
    Pendulum1D{FT} <: Oscillator1D{FT}

Settings of a 1D pendulum oscillator.
"""
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

"""
    Pendulum1D(; m::T, c::T, L::T, g::AbstractFloat=9.81) where {T<:AbstractFloat}

Constructor for Pendulum1D with named arguments.
"""
function Pendulum1D(; m::T, c::T, L::T, g::AbstractFloat=9.81) where {T<:AbstractFloat}
    Pendulum1D(m, c, L, T(g))
end

function (a::Accelerator1D{<:Pendulum1D,Dim})(
    x::FT, dx::FT, y::FT, dy::FT, z::FT, dz::FT, t::FT
) where {FT<:AbstractFloat,Dim}
    q, dq = _get_coord(Dim, x, dx, y, dy, z, dz)
    return (a.force_field(x, y, z, t) / a.oscillator.mL) - a.oscillator.c_over_m * dq -
           a.oscillator.g_over_L * sin(q)
end

"""
    Spring1D{FT} <: Oscillator1D{FT}

Settings of a 1D spring oscillator.
"""
struct Spring1D{FT} <: Oscillator1D{FT}
    m::FT
    c::FT
    k::FT
end

"""
    RLC1D{FT} <: Oscillator1D{FT}

Settings of a 1D RLC circuit oscillator.
"""
struct RLC1D{FT} <: Oscillator1D{FT}
    R::FT
    L::FT
    C::FT
end
