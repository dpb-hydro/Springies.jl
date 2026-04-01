
"""
    Oscillator3D{FT<:AbstractFloat}

Type to store three `Oscillator1D{FT}` objects, one for each dimension `x`, `y`, `z`.
"""
struct Accelerator3D
    x::Accelerator1D
    y::Accelerator1D
    z::Accelerator1D
end

Base.eltype(::Accelerator1D{OT}) where {OT} = OT

function Accelerator3D(;
    x::Accelerator1D=Accelerator1D(),
    y::Accelerator1D=Accelerator1D(),
    z::Accelerator1D=Accelerator1D(),
)
    Accelerator3D(x, y, z)
end

function (a::Accelerator1D{<:EmptyOscillator})(
    x::FT, y::FT, z::FT, dx::FT, dy::FT, dz::FT, t::FT
) where {FT<:AbstractFloat}
    return zero(FT)
end
