"""
    ForceField{FT<:AbstractFloat}

Abstract supertype for all force fields.
"""
abstract type ForceField{FT<:AbstractFloat} end

"""
    ZeroForce{FT} <: ForceField{FT}

Empty type to represent absence of force.
"""
struct ZeroForce{FT} <: ForceField{FT}
    function ZeroForce(::Type{FT}) where {FT<:AbstractFloat}
        new{FT}()
    end
end

function (f::ZeroForce{FT})(x::FT, y::FT, z::FT, t::FT) where {FT<:AbstractFloat}
    zero(FT)
end
