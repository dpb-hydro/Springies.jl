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
