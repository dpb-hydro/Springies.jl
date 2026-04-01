"""
    Oscillator

Abstract supertype for all oscillators.
"""
abstract type Oscillator end

"""
    Oscillator1D{T}

Abstract supertype for all 1D oscillators.
"""
abstract type Oscillator1D{T} <: Oscillator end

"""
    EmptyOscillator{FT} <: Oscillator1D{FT}

Empty type to represent absence of an oscillator.
"""
struct EmptyOscillator{FT} <: Oscillator1D{FT}
    function EmptyOscillator(::Type{T}) where {T<:AbstractFloat}
        new{T}()
    end
end

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

"""
    Accelerator

Abstract supertype for all accelerators.
"""
abstract type Accelerator end

"""
    Accelerator1D{OT<:Oscillator1D}

Type for 1D accelerators.
"""
struct Accelerator1D{OT<:Oscillator1D} <: Accelerator
    oscillator::OT
    force_field::ForceField
end

"""
    eltype(::Accelerator1D{OT}) where {OT}

Return Oscillator1D type `OT` used by an `Accelerator1D` object.
"""
Base.eltype(::Accelerator1D{OT}) where {OT} = OT
