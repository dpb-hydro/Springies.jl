
"""
    Spring1D{FT} <: Oscillator1D{FT}

Settings of a 1D spring oscillator.
"""
struct Spring1D{FT} <: Oscillator1D{FT}
    m::FT
    c::FT
    k::FT
end
