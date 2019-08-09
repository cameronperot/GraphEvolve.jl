"""
	compute_Δ_method_1!(g::AbstractGraph)

Determines `t₀` and `t₁` for the given evolved `g`

Arguments
* `g` : An evolved instance of type AbstractGraph
Extra Information
* `t₀`: The last step in the evolution process satisfying `g.observables.largest_cluster_size < sqrt(g.n)`
* `t₁`: The first step in the evolution process satisfying `g.observables.largest_cluster_size > 0.5g.n`
Returns
* `nothing`, updates `g` in-place
"""
function compute_Δ_method_1!(g::AbstractGraph)
	t₀ = sum(g.observables.largest_cluster_size .< sqrt(g.n)) - 1
	t₁ = sum(g.observables.largest_cluster_size .<= 0.5g.n)

	C₀ = g.observables.largest_cluster_size[t₀+1]
	if t₁ > g.t
		C₁ = NaN
	else
		C₁ = g.observables.largest_cluster_size[t₁+1]
	end

	g.observables.Δ_method_1 = (t₀, t₁, C₀, C₁) ./ g.n
	return nothing
end


"""
	compute_Δ_method_2!(g::AbstractGraph)

Determines `t₀` and `t₁` for the given evolved `g`

Arguments
* `g` : An evolved instance of type AbstractGraph
Extra Information
* `t₀`: The step in the evolution process where the heterogeneity peaks
* `t₁`: The step in the evolution process where the size of the largest cluster increases the most
Returns
* `nothing`, updates `g` in-place
"""
function compute_Δ_method_2!(g::AbstractGraph)
	t₀ = argmax(g.observables.heterogeneity) - 1 # because t+1 observations when t edges active
	t₁ = argmax(
		[g.observables.largest_cluster_size[i+1] - g.observables.largest_cluster_size[i]
		for i in 1:length(g.observables.largest_cluster_size)-1]
	)

	C₀ = g.observables.largest_cluster_size[t₀+1]
	C₁ = g.observables.largest_cluster_size[t₁+1]

	g.observables.Δ_method_2 = (t₀, t₁, C₀, C₁) ./ g.n
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
	compute_Δ_method_1!(g)
	compute_Δ_method_2!(g)
	return nothing
end
