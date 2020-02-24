# Edge Methods

```@docs
choose_edge(g::Network)
choose_edge(g::Lattice2D)
choose_edge(g::Lattice3D)
choose_edge(g::AbstractGraph, edge₁::NTuple{2, Integer})
choose_edge(g::AbstractGraph, edges::Array{NTuple{2, Integer}, 1})
add_edge!(g::AbstractGraph, edge::NTuple{2, Integer})
nearest_neighbors(g::Lattice2D, node::NTuple{2, Integer})
nearest_neighbors(g::Lattice3D, node::NTuple{3, Integer})
cart_to_lin(cart::Tuple, L::Integer)
```
