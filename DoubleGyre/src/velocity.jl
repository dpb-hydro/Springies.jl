"""
    gyre_stream(G, x, y, t)

Stream function for a Double Gyre field with properties `G` at point (`x`, `y`) and time `t`.
"""
function gyre_stream(G::GyreProperties, x::Real, y::Real, t::Real)
    a = G.e * sin(G.omega * t)
    fx = a * x^2 + (1 - 2a) * x
    return G.A * sin(pi * fx) * sin(pi * y)
end

"""
    gyre_uv(G, x, y, t)

Compute velocity in a Double Gyre field with properties `G` at point (`x`, `y`) and time `t`.
"""
function gyre_uv(G::GyreProperties, x::Real, y::Real, t::Real)
    u = -ForwardDiff.derivative(a -> gyre_stream(G, x, a, t), y)
    v = ForwardDiff.derivative(b -> gyre_stream(G, b, y, t), x)
    return [u, v]
end
