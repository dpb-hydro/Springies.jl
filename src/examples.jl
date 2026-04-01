
function (a::Accelerator1D{<:Pendulum1D})(
    x::FT, y::FT, z::FT, dx::FT, dy::FT, dz::FT, t::FT
) where {FT<:AbstractFloat}
    return (a.force_field(x, y, z, t) / a.oscillator.mL) - a.oscillator.c_over_m * dx -
           a.oscillator.g_over_L * sin(x)
end

struct CosineForce{FT<:AbstractFloat} <: ForceField{FT}
    F0::FT
    omega::FT
end
(f::CosineForce)(x, y, z, t) = f.F0 * cos(f.omega * t)
