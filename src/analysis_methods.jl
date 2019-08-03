"""
	compute_Δ_method_1!(g::AbstractGraph)

Determines `Δ`, `t₀`, and `t₁` for the given evolved `g`

Arguments
* `g` : An evolved instance of type AbstractGraph
Extra Information
* `Δ` : `t₁ - t₀`
* `t₀`: The last step in the evolution process satisfying `g.observables.largest_cluster_size < sqrt(g.n)`
* `t₁`: The first step in the evolution process satisfying `g.observables.largest_cluster_size > 0.5g.n`
Returns
* None, updates `g` in-place
"""
function compute_Δ_method_1!(g::AbstractGraph)
	t₀ = sum(g.observables.largest_cluster_size .< sqrt(g.n))
	t₁ = sum(g.observables.largest_cluster_size .<= 0.5g.n) + 1
	g.observables.Δ_method_1 = (t₁-t₀, t₀, t₁) ./ g.n
end


"""
	compute_Δ_method_2!(g::AbstractGraph)

Determines `Δ`, `t₀`, and `t₁` for the given evolved `g`

Arguments
* `g` : An evolved instance of type AbstractGraph
Extra Information
* `Δ` : `t₁ - t₀`
* `t₀`: The step in the evolution process where the heterogeneity peaks
* `t₁`: The step in the evolution process where the size of the largest cluster increases the most
Returns
* None, updates `g` in-place
"""
function compute_Δ_method_2!(g::AbstractGraph)
	t₀ = argmax(g.observables.heterogeneity)
	t₁ = argmax(
		[g.observables.largest_cluster_size[i+1] - g.observables.largest_cluster_size[i]
		for i in 1:length(g.observables.largest_cluster_size)-1]
	)
	g.observables.Δ_method_2 = (t₁-t₀, t₀, t₁) ./ g.n
end


"""
	finalize_observables!(g::AbstractGraph)

Finalize the observables for the given evolved `g`

Arguments
* `g` : An evolved instance of type AbstractGraph
Returns
* None, updates `g` in-place
"""
function finalize_observables!(g::AbstractGraph)
	compute_Δ_method_1!(g)
	compute_Δ_method_2!(g)
end
