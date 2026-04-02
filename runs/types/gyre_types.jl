struct Spring1D{FT} <: Oscillator1D{FT}
    m::FT
    c::FT
    k::FT
    x0::FT
    y0::FT
    c_over_m::FT
    k_over_m::FT
    function Spring1D(m::T, c::T, k::T, x0::T, y0::T) where {T<:AbstractFloat}
        new{T}(m, c, k, x0, y0, c/m, k/m)
    end
end

function (a::Accelerator1D{<:Spring1D,Dim})(
    x::FT, dx::FT, y::FT, dy::FT, z::FT, dz::FT, t::FT
) where {FT<:AbstractFloat,Dim}
    q, dq = get_coord(Dim, x, dx, y, dy, z, dz)
    q0 = get_coord(Dim, a.oscillator.x0, a.oscillator.y0)
    return (a.force_field(x, y, z, t) / a.oscillator.m) - a.oscillator.c_over_m * dq -
           a.oscillator.k_over_m * (q - q0)
end

"""
    GyreProperties{T<:AbstractFloat}

Properties of the Double Gyre field.

# Fields
- `A`: Velocity magnitude control
- `e`: Wobble size control
- `omega`: Wobble angular frequency
"""
struct GyreProperties{T<:AbstractFloat}
    A::T
    e::T
    omega::T
end

"""
    gyre_stream(G, x, y, t)

Stream function for a Double Gyre field with properties `G` at point (`x`, `y`) and time `t`.
"""
function gyre_stream(G::GyreProperties, x::Real, y::Real, t::Real)
    a = G.e * sin(G.omega * t)
    fx = a * x^2 + (1 - 2a) * x
    return G.A * sin(pi * fx) * sin(pi * y)
end

struct GyreFX{FT<:AbstractFloat} <: ForceField{FT}
    G::GyreProperties{FT}
end
(f::GyreFX)(x, y, z, t) = -ForwardDiff.derivative(a -> gyre_stream(G, x, a, t), y)

struct GyreFY{FT<:AbstractFloat} <: ForceField{FT}
    G::GyreProperties{FT}
end
(f::GyreFY)(x, y, z, t) = ForwardDiff.derivative(b -> gyre_stream(G, b, y, t), x)

function gyre_uv(G::GyreProperties, x::Real, y::Real, t::Real)
    u = -ForwardDiff.derivative(a -> gyre_stream(G, x, a, t), y)
    v = ForwardDiff.derivative(b -> gyre_stream(G, b, y, t), x)
    return [u, v]
end
