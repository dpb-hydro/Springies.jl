
function (a::Accelerator1D{<:Spring1D,Dim})(
    x::FT, dx::FT, y::FT, dy::FT, z::FT, dz::FT, t::FT
) where {FT<:AbstractFloat,Dim}
    q, dq = get_coord(Dim, x, dx, y, dy, z, dz)
    q0 = get_coord(Dim, a.oscillator.x0, a.oscillator.y0)
    return (a.force_field(x, y, z, t) / a.oscillator.m) - a.oscillator.c_over_m * dq -
           a.oscillator.k_over_m * (q - q0)
end

struct GyreFX{FT<:AbstractFloat} <: ForceField{FT}
    G::GyreProperties{FT}
end
(f::GyreFX)(x, y, z, t) = -ForwardDiff.derivative(a -> gyre_stream(f.G, x, a, t), y)

struct GyreFY{FT<:AbstractFloat} <: ForceField{FT}
    G::GyreProperties{FT}
end

(f::GyreFY)(x, y, z, t) = ForwardDiff.derivative(b -> gyre_stream(f.G, b, y, t), x)
