# Edge Methods

```@docs
choose_edge(g::Network)
choose_edge(g::Lattice2D)
choose_edge(g::Lattice3D)
choose_edge(g::AbstractGraph, edge₁::Tuple)
choose_edge(g::AbstractGraph, edges::Array{Tuple{Int, Int}, 1})
add_edge!(g::AbstractGraph, edge::Tuple)
nearest_neighbors(g::Lattice2D, node::Tuple{Int, Int})
nearest_neighbors(g::Lattice3D, node::Tuple{Int, Int, Int})
cart_to_lin(cart::Tuple, L::Int)
```
