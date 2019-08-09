"""
	AbstractGraph

Abstract type

Subtypes
* AbstractNetwork
* AbstractLattice
"""
abstract type AbstractGraph end


"""
	AbstractNetwork

Abstract subtype of AbstractGraph

Subtypes
* Network
"""
abstract type AbstractNetwork <: AbstractGraph end


"""
	AbstractLattice

Abstract subtype of AbstractGraph

Subtypes
* Lattice2D
* Lattice3D
"""
abstract type AbstractLattice <: AbstractGraph end


"""
	Observables

Contains the observables associated to a percolation simulation.

Attributes
* `avg_cluster_size`     : Array where `avg_cluster_size[t]` is the average cluster size at step `t-1`
* `heterogeneity`        : Array where `heterogeneity[t]` is the number of unique cluster sizes at step `t-1`
* `largest_cluster_size` : Array where `C[t]` is the largest cluster size at step `t-1`
* `delta`                : See analysis_methods.compute_delta for more info
"""
mutable struct Observables
	avg_cluster_size     ::Array{Float64, 1}
	heterogeneity        ::Array{Int, 1}
	largest_cluster_size ::Array{Int, 1}
	delta           ::Tuple

	function Observables()
		avg_cluster_size     = [1.0]
		heterogeneity        = [1]
		largest_cluster_size = [1]
		delta           = ()

		new(avg_cluster_size,
			heterogeneity,
			largest_cluster_size,
			delta
		)
	end
end


"""
	Network(n::Int; seed::Int=8)

This type represents a random network in which edges are allowed to be active between any two of the `n` nodes.
It houses information about the nodes, edges, clusters, and observables.

Arguments
* `n`               : Total number of nodes in the network
Keyword Arguments
* `seed`            : Seed value for the random number generator (default = 8)
Returns
* `g`               : A new instance of type Network
Attributes
* `n`               : Total number of nodes in the network
* `t`               : Current step in the evolution process, number of edges in the network
* `edges`           : Set of edges present in the network
* `cluster_ids`     : Array with nodes as indices and cluster IDs as values
* `clusters`        : Dictionary with cluster IDs as keys and clusters as values
* `cluster_sizes`   : Dictionary with cluster sizes as keys and cluster counts as values, i.e. cluster size distribution
* `rng`             : Random number generator
* `observables`     : Custom type containing observables associated with `g`
"""
mutable struct Network <: AbstractNetwork
	n               ::Int
	t               ::Int
	edges           ::Set{Tuple{Int, Int}}
	cluster_ids     ::Array{Int, 1}
	clusters        ::Dict{Int, Set{Int}}
	cluster_sizes   ::Dict{Int, Int}
	rng             ::MersenneTwister
	observables     ::Observables

	function Network(n::Int; seed::Int=8)
		t                = 0
		edges            = Set()
		cluster_ids      = collect(1:n)
		clusters         = Dict(1:n .=> Set.(1:n))
		cluster_sizes    = Dict(1 => n)
		rng              = MersenneTwister(seed)
		observables      = Observables()

		new(n,
			t,
			edges,
			cluster_ids,
			clusters,
			cluster_sizes,
			rng,
			observables
		)
	end
end


"""
	Lattice2D(L::Int; seed::Int=8)

This type represents a 2D lattice in which edges are only allowed to be active between nearest neighbors.
It houses information about the nodes, edges, clusters, and observables.

Arguments
* `L`               : Side length of the square lattice
Keyword Arguments
* `seed`            : Seed value for the random number generator (default = 8)
Returns
* `g`               : A new instance of type Lattice2D
Attributes
* `L`               : Side length of the square lattice
* `n`               : Total number of nodes in the lattice, `n = L^2`
* `t`               : Current step in the evolution process, number of edges in the lattice
* `edges`           : Set of edges present in the lattice
* `cluster_ids`     : Array with nodes as indices and cluster IDs as values
* `clusters`        : Dictionary with cluster IDs as keys and clusters as values
* `cluster_sizes`   : Dictionary with cluster sizes as keys and cluster counts as values, i.e. cluster size distribution
* `rng`             : Random number generator
* `observables`     : Custom type containing observables associated with `g`
"""
mutable struct Lattice2D <: AbstractLattice
	L               ::Int
	n               ::Int
	t               ::Int
	edges           ::Set{Tuple{Int, Int}}
	cluster_ids     ::Array{Int, 2}
	clusters        ::Dict{Int, Set{Int}}
	cluster_sizes   ::Dict{Int, Int}
	rng             ::MersenneTwister
	observables     ::Observables

	function Lattice2D(L::Int; seed::Int=8)
		n                = L^2
		t                = 0
		edges            = Set()
		cluster_ids      = reshape(collect(1:n), (L, L))
		clusters         = Dict(1:n .=> Set.(1:n))
		cluster_sizes    = Dict(1 => n)
		rng              = MersenneTwister(seed)
		observables      = Observables()

		new(L,
			n,
			t,
			edges,
			cluster_ids,
			clusters,
			cluster_sizes,
			rng,
			observables
		)
	end
end


"""
	Lattice3D(L::Int; seed::Int=8)

This type represents a 3D lattice in which edges are only allowed to be active between nearest neighbors.
It houses information about the nodes, edges, clusters, and observables.

Arguments
* `L`               : Side length of the cubic lattice
Keyword Arguments
* `seed`            : Seed value for the random number generator (default = 8)
Returns
* `g`               : A new instance of type Lattice3D
Attributes
* `L`               : Side length of the cubic lattice
* `n`               : Total number of nodes in the lattice, `n = L^3`
* `t`               : Current step in the evolution process, number of edges in the lattice
* `edges`           : Set of edges present in the lattice
* `cluster_ids`     : Array with nodes as indices and cluster IDs as values
* `clusters`        : Dictionary with cluster IDs as keys and clusters as values
* `cluster_sizes`   : Dictionary with cluster sizes as keys and cluster counts as values, i.e. cluster size distribution
* `rng`             : Random number generator
* `observables`     : Custom type containing observables associated with `g`
"""
mutable struct Lattice3D <: AbstractLattice
	L               ::Int
	n               ::Int
	t               ::Int
	edges           ::Set{Tuple{Int, Int}}
	cluster_ids     ::Array{Int, 3}
	clusters        ::Dict{Int, Set{Int}}
	cluster_sizes   ::Dict{Int, Int}
	rng             ::MersenneTwister
	observables     ::Observables

	function Lattice3D(L::Int; seed::Int=8)
		n                = L^3
		t                = 0
		edges            = Set()
		cluster_ids      = reshape(collect(1:n), (L, L, L))
		clusters         = Dict(1:n .=> Set.(1:n))
		cluster_sizes    = Dict(1 => n)
		rng              = MersenneTwister(seed)
		observables      = Observables()

		new(L,
			n,
			t,
			edges,
			cluster_ids,
			clusters,
			cluster_sizes,
			rng,
			observables
		)
	end
end
