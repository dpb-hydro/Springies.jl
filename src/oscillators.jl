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
