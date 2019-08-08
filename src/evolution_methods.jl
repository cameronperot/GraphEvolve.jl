"""
	erdos_renyi!(g::AbstractGraph, n_steps::Int)

Erdos-Renyi style graph evolution, adds edges randomly at each step

Arguments
* `g`      : An instance of type AbstractGraph
* `n_steps`: Number of edges to add to the AbstractGraph
Returns
* `g`, updates `g` in-place
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
* `K`      : Bounded size of clusters upon which to determine edge acceptance (default = 2)
Returns
* `g`, updates `g` in-place
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
* `g`, updates `g` in-place
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

Achlioptas process, a probability based model for accepting edges

Arguments
* `g`      : An instance of type AbstractGraph
* `n_steps`: Number of edges to add to the AbstractGraph
Returns
* `g`, updates `g` in-place
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


"""
	stochastic_edge_acceptance!(g::AbstractGraph, n_steps::Int, q::Int)

q-edge Achlioptas process, a probability based model for accepting edges

Arguments
* `g`      : An instance of type AbstractGraph
* `n_steps`: Number of edges to add to the AbstractGraph
* `q`      : Number of edges to evaluate
Returns
* `g`, updates `g` in-place
"""
function stochastic_edge_acceptance!(g::AbstractGraph, n_steps::Int, q::Int)
	for t in 1:n_steps
		edges = [choose_edge(g)]
		for i in 1:q-1
			push!(edges, choose_edge(g, edges))
		end

		edge_added = false
		for edge in edges
			if g.cluster_ids[edge[1]] == g.cluster_ids[edge[2]]
				add_edge!(g, edge)
				edge_added = true
				break
			end
		end
		if edge_added continue end

		C = [(length(g.clusters[g.cluster_ids[edge[1]]]) + length(g.clusters[g.cluster_ids[edge[2]]]))
			for edge in edges
		]
		p = (1 ./ C) ./ sum(1 ./ C)
		R = rand(g.rng)
		P = 0
		for i in 1:q
			P += p[i]
			if R < P
				add_edge!(g, edges[i])
				break
			end
		end
	end

	finalize_observables!(g)
	return g
end


"""
	stochastic_edge_acceptance!(g::AbstractGraph, n_steps::Int, q::Int)

q-edge Achlioptas process, a probability based model for accepting edges

Arguments
* `g`      : An instance of type AbstractGraph
* `n_steps`: Number of edges to add to the AbstractGraph
* `q`      : Number of edges to evaluate
Returns
* `g`, updates `g` in-place
"""
function stochastic_edge_acceptance!(g::AbstractGraph, n_steps::Int, t_data::Dict, savepath::String)
	t₀, t₁ = t_data[(g.n, Int(g.rng.seed[1]))]
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

		if t == t₀
			save(
				joinpath(
					savepath,
					"t_0",
					"$(typeof(g))_stochastic_edge_acceptance_$(Int(log2(g.n)))_t_0_cluster_size_distribution_seed_$(Int(g.rng.seed[1])).jld"
				),
				"n",
				g.n,
				"t_0_cluster_size_distribution",
				g.cluster_sizes,
			)
		end
		if t == t₁
			save(
				joinpath(
					savepath,
					"t_1",
					"$(typeof(g))_stochastic_edge_acceptance_$(Int(log2(g.n)))_t_1_cluster_size_distribution_seed_$(Int(g.rng.seed[1])).jld"
				),
				"n",
				g.n,
				"t_1_cluster_size_distribution",
				g.cluster_sizes,
			)
		end
	end

	finalize_observables!(g)
	return g
end
