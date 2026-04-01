
function (a::Accelerator1D{<:EmptyOscillator})(
    x::FT, y::FT, z::FT, dx::FT, dy::FT, dz::FT, t::FT
) where {FT<:AbstractFloat}
    return zero(FT)
end
