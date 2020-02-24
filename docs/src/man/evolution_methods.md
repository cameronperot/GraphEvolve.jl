# Evolution Methods

```@docs
erdos_renyi!(g::AbstractGraph, n_steps::Integer)
bohman_frieze!(g::AbstractGraph, n_steps::Integer; K::Integer=2)
product_rule!(g::AbstractGraph, n_steps::Integer)
stochastic_edge_acceptance!(g::AbstractGraph, n_steps::Integer)
stochastic_edge_acceptance!(g::AbstractGraph, n_steps::Integer, q::Integer)
```
