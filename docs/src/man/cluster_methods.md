# Cluster Methods

```@docs
get_cluster(g::AbstractGraph, node::Int)
get_largest_cluster_size(g::AbstractGraph)
get_avg_cluster_size(g::AbstractGraph)
get_largest_clusters(g::AbstractGraph, n_clusters::Int)
update_clusters!(g::AbstractGraph, edge::Tuple)
update_cluster_sizes!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
update_cluster_ids!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
merge_clusters!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
update_observables!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
```
