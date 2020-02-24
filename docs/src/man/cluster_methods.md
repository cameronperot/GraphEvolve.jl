# Cluster Methods

```@docs
get_cluster(g::AbstractGraph, node::Integer)
get_largest_cluster_size(g::AbstractGraph)
get_avg_cluster_size(g::AbstractGraph)
get_largest_clusters(g::AbstractGraph, n_clusters::Integer)
update_clusters!(g::AbstractGraph, edge::NTuple{2, Integer})
update_cluster_sizes!(g::AbstractGraph, larger_cluster_id::Integer, smaller_cluster_id::Integer)
update_cluster_ids!(g::AbstractGraph, larger_cluster_id::Integer, smaller_cluster_id::Integer)
merge_clusters!(g::AbstractGraph, larger_cluster_id::Integer, smaller_cluster_id::Integer)
update_observables!(g::AbstractGraph, larger_cluster_id::Integer, smaller_cluster_id::Integer)
```
