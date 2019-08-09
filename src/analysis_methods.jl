"""
	compute_delta!(g::AbstractGraph)

Determines `t₀` and `t₁` for the given evolved `g`

Arguments
* `g` : An evolved instance of type AbstractGraph
Extra Information
* `t₀`: The step in the evolution process where the heterogeneity peaks
* `t₁`: The step in the evolution process where the size of the largest cluster increases the most
Returns
* `nothing`, updates `g` in-place
"""
function compute_delta!(g::AbstractGraph)
	t₀ = argmax(g.observables.heterogeneity) - 1 # because t+1 observations when t edges active
	t₁ = argmax(
		[g.observables.largest_cluster_size[i+1] - g.observables.largest_cluster_size[i]
		for i in 1:length(g.observables.largest_cluster_size)-1]
	)

	C₀ = g.observables.largest_cluster_size[t₀+1]
	C₁ = g.observables.largest_cluster_size[t₁+1]

	g.observables.delta = (t₀, t₁, C₀, C₁) ./ g.n
	return nothing
end


"""
	finalize_observables!(g::AbstractGraph)

Finalize the observables for the given evolved `g`

Arguments
* `g` : An evolved instance of type AbstractGraph
Returns
* `nothing`, updates `g` in-place
"""
function finalize_observables!(g::AbstractGraph)
	compute_delta!(g)
	return nothing
end
