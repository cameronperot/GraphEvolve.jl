"""
	erdos_renyi!(g::AbstractGraph, n_steps::Int)

Erdos-Renyi style graph evolution, adds edges randomly at each step

Arguments
* `g`      : An instance of type AbstractGraph
* `n_steps`: Number of edges to add to the AbstractGraph
Returns
* None, updates `g` in-place
"""
function erdos_renyi!(g::AbstractGraph, n_steps::Int)
	for t in 1:n_steps
		edge = choose_edge(g)
		add_edge!(g, edge)
	end

	finalize_observables!(g)
	return g
end


"""
	bohman_frieze!(g::AbstractGraph, n_steps::Int; K::Int=2)

Achlioptas process, implementation of Bohman-Frieze bounded size rule

Arguments
* `g`      : An instance of type AbstractGraph
* `n_steps`: Number of edges to add to the AbstractGraph
Keyword Arguments
* `K`      : Bounded size of clusters upon which to determine edge acceptance (default = 1)
Returns
* None, updates `g` in-place
"""
function bohman_frieze!(g::AbstractGraph, n_steps::Int; K::Int=2)
	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if length(g.clusters[g.cluster_ids[edge₁[1]]]) < K && length(g.clusters[g.cluster_ids[edge₁[2]]]) < K
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end

	finalize_observables!(g)
	return g
end


"""
	product_rule!(g::AbstractGraph, n_steps::Int)

Achlioptas process, implementation of the product rule

Arguments
* `g`      : An instance of type AbstractGraph
* `n_steps`: Number of edges to add to the AbstractGraph
Returns
* None, updates `g` in-place
"""
function product_rule!(g::AbstractGraph, n_steps::Int)
	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if g.cluster_ids[edge₁[1]] == g.cluster_ids[edge₁[2]]
			add_edge!(g, edge₁)
		elseif g.cluster_ids[edge₂[1]] == g.cluster_ids[edge₂[2]]
			add_edge!(g, edge₂)
		elseif length(g.clusters[g.cluster_ids[edge₁[1]]]) * length(g.clusters[g.cluster_ids[edge₁[2]]]) < length(g.clusters[g.cluster_ids[edge₂[1]]]) * length(g.clusters[g.cluster_ids[edge₂[2]]])
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end

	finalize_observables!(g)
	return g
end


"""
	stochastic_edge_acceptance!(g::AbstractGraph, n_steps::Int)

Achlioptas process, a probability based rule for accepting edges

Arguments
* `g`      : An instance of type AbstractGraph
* `n_steps`: Number of edges to add to the AbstractGraph
* `q`      : Minimum probability that edge₁ is accepted
Returns
* None, updates `g` in-place
"""
function stochastic_edge_acceptance!(g::AbstractGraph, n_steps::Int)
	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if g.cluster_ids[edge₁[1]] == g.cluster_ids[edge₁[2]]
			add_edge!(g, edge₁)
		elseif g.cluster_ids[edge₂[1]] == g.cluster_ids[edge₂[2]]
			add_edge!(g, edge₂)
		else
			C₁ = length(g.clusters[g.cluster_ids[edge₁[1]]]) + length(g.clusters[g.cluster_ids[edge₁[2]]])
			C₂ = length(g.clusters[g.cluster_ids[edge₂[1]]]) + length(g.clusters[g.cluster_ids[edge₂[2]]])
			p = (1 / C₁) / (1 / C₁ + 1 / C₂)

			if p > rand(g.rng)
				add_edge!(g, edge₁)
			else
				add_edge!(g, edge₂)
			end
		end
	end

	finalize_observables!(g)
	return g
end
