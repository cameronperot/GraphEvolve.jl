"""
	get_cluster(g::AbstractGraph, node::Int)

Determines the cluster in `g` which `node` is a member of

Arguments
* `g`   : An instance of type AbstractGraph
* `node`: Node in `keys(g.cluster_ids)`
Returns
* Set of nodes representing the cluster which `node` is a member of
"""
function get_cluster(g::AbstractGraph, node::Int)
	return g.clusters[g.cluster_ids[node]]
end


"""
	get_largest_cluster_size(g::AbstractGraph)

Determines the size of the largest cluster in `g`

Arguments
* `g`: An instance of type AbstractGraph
Returns
* Integer representing the number of nodes in the largest cluster in `g`
"""
function get_largest_cluster_size(g::AbstractGraph)
	return maximum(keys(g.cluster_sizes))
end


"""
	get_avg_cluster_size(g::AbstractGraph)

Determines the average cluster size in `g`

Arguments
* `g`: An instance of type AbstractGraph
Returns
* Float64 representing the average cluster size in `g`
"""
function get_avg_cluster_size(g::AbstractGraph)
	return sum([key * value for (key, value) in g.cluster_sizes]) / length(g.clusters)
end


"""
	get_largest_clusters(g::AbstractGraph, n_clusters::Int)

Determines the `n_clusters` largest clusters in 'g'

Arguments
* `g`         : An instance of type AbstractGraph
* `n_clusters`: The number of largest clusters to return
Returns
* Sorted (descending) array of the `n_clusters` largest clusters in `g`
"""
function get_largest_clusters(g::AbstractGraph, n_clusters::Int)
	return sort!(collect(values(g.clusters)), by=length, rev=true)[1:n_clusters]
end


"""
	update_clusters!(g::AbstractGraph, edge::Tuple)

Updates `g` with the newly merged cluster and the largest cluster size
Arguments
* `g`   : An instance of type AbstractGraph
* `edge`: Edge added to `g` at step `g.t`
Returns
* None, updates `g` in-place
"""
function update_clusters!(g::AbstractGraph, edge::Tuple)
	if length(g.clusters[g.cluster_ids[edge[1]]]) > length(g.clusters[g.cluster_ids[edge[2]]])
		larger_cluster_id  = g.cluster_ids[edge[1]]
		smaller_cluster_id = g.cluster_ids[edge[2]]
	else
		larger_cluster_id  = g.cluster_ids[edge[2]]
		smaller_cluster_id = g.cluster_ids[edge[1]]
	end

	if g.cluster_ids[edge[1]] ≠ g.cluster_ids[edge[2]]
		update_cluster_sizes!(g, larger_cluster_id, smaller_cluster_id)
		update_cluster_ids!(g, larger_cluster_id, smaller_cluster_id)
		merge_clusters!(g, larger_cluster_id, smaller_cluster_id)
		update_observables!(g, larger_cluster_id, smaller_cluster_id)
	else
		update_observables!(g, larger_cluster_id, smaller_cluster_id)
	end
end


"""
	update_cluster_sizes!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)

Updates the cluster size distribution dictionary

Arguments
* `g`                 : An instance of type AbstractGraph
* `larger_cluster_id` : Cluster ID of the larger cluster
* `smaller_cluster_id`: Cluster ID of the smaller cluster
Returns
* None, updates `g` in-place
"""
function update_cluster_sizes!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
	if g.cluster_sizes[length(g.clusters[smaller_cluster_id])] ≠ 1
		g.cluster_sizes[length(g.clusters[smaller_cluster_id])] -= 1
	else
		delete!(g.cluster_sizes, length(g.clusters[smaller_cluster_id]))
	end

	if g.cluster_sizes[length(g.clusters[larger_cluster_id])] ≠ 1
		g.cluster_sizes[length(g.clusters[larger_cluster_id])] -= 1
	else
		delete!(g.cluster_sizes, length(g.clusters[larger_cluster_id]))
	end

	if haskey(g.cluster_sizes, (length(g.clusters[larger_cluster_id]) + length(g.clusters[smaller_cluster_id])))
		g.cluster_sizes[(length(g.clusters[larger_cluster_id]) + length(g.clusters[smaller_cluster_id]))] += 1
	else
		g.cluster_sizes[(length(g.clusters[larger_cluster_id]) + length(g.clusters[smaller_cluster_id]))] = 1
	end
end


"""
	update_cluster_ids!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)

Updates the cluster IDs of the nodes in the smaller cluster to that of the larger cluster it is being merged into

Arguments
* `g`                 : An instance of type AbstractGraph
* `larger_cluster_id` : Cluster ID of the larger cluster
* `smaller_cluster_id`: Cluster ID of the smaller cluster
Returns
* None, updates `g` in-place
"""
function update_cluster_ids!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
	for node in g.clusters[smaller_cluster_id]
		g.cluster_ids[node] = larger_cluster_id
	end
end


"""
	merge_clusters!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)

Mergers the smaller cluster into the larger cluster in-place

Arguments
* `g`                 : An instance of type AbstractGraph
* `larger_cluster_id` : Cluster ID of the larger cluster
* `smaller_cluster_id`: Cluster ID of the smaller cluster
Returns
* None, updates `g` in-place
"""
function merge_clusters!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
	union!(g.clusters[larger_cluster_id], g.clusters[smaller_cluster_id])
	delete!(g.clusters, smaller_cluster_id)
end


"""
	update_observables!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)

Updates the largest cluster size, average cluster size, and cluster heterogeneity

Arguments
* `g`                 : An instance of type AbstractGraph
* `larger_cluster_id` : Cluster ID of the larger cluster
* `smaller_cluster_id`: Cluster ID of the smaller cluster
Returns
* None, updates `g` in-place
"""
function update_observables!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
	push!(g.observables.largest_cluster_size, maximum((g.observables.largest_cluster_size[g.t], length(g.clusters[larger_cluster_id]))))
	push!(g.observables.avg_cluster_size, get_avg_cluster_size(g))
	push!(g.observables.heterogeneity, length(g.cluster_sizes))
end
