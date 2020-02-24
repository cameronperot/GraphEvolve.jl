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
	delta                ::Tuple

	function Observables()
		avg_cluster_size     = [1.0]
		heterogeneity        = [1]
		largest_cluster_size = [1]
		delta                = ()

		new(avg_cluster_size,
			heterogeneity,
			largest_cluster_size,
			delta
		)
	end
end


"""
	Network(N::Integer; T::Type{<:Integer}=UInt32, seed::Integer=8)

This type represents a random network in which edges are allowed to be active between any two of the `N` nodes.
It houses information about the nodes, edges, clusters, and observables.

Arguments
* `N`               : Total number of nodes in the network
Keyword Arguments
* `T`               : Type of Integer to use for tracking the clusters (default = UInt32)
* `seed`            : Seed value for the random number generator (default = 8)
Returns
* `g`               : A new instance of type Network
Attributes
* `N`               : Total number of nodes in the network
* `t`               : Current step in the evolution process, number of edges in the network
* `edges`           : Set of edges present in the network
* `cluster_ids`     : Array with nodes as indices and cluster IDs as values
* `clusters`        : Dictionary with cluster IDs as keys and clusters as values
* `cluster_sizes`   : Dictionary with cluster sizes as keys and cluster counts as values, i.e. cluster size distribution
* `rng`             : Random number generator
* `observables`     : Custom type containing observables associated with `g`
"""
mutable struct Network{T <: Integer} <: AbstractNetwork
	N               ::Int
	t               ::Int
	edges           ::Set{Tuple{T, T}}
	cluster_ids     ::Array{T, 1}
	clusters        ::Dict{T, Set{T}}
	cluster_sizes   ::Dict{T, T}
	rng             ::MersenneTwister
	observables     ::Observables

	function Network(N::Integer; T::Type{<:Integer}=UInt32, seed::Integer=8)
		t                = 0
		edges            = Set()
		cluster_ids      = collect(UnitRange{T}(1, N))
		clusters         = Dict(UnitRange{T}(1, N) .=> Set.(UnitRange{T}(1, N)))
		cluster_sizes    = Dict(T(1) => T(N))
		rng              = MersenneTwister(seed)
		observables      = Observables()

		new{T}(N,
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
	Lattice2D(L::Integer; T::Type{<:Integer}=UInt32, seed::Integer=8)

This type represents a 2D lattice in which edges are only allowed to be active between nearest neighbors.
It houses information about the nodes, edges, clusters, and observables.

Arguments
* `L`               : Side length of the square lattice
Keyword Arguments
* `T`               : Type of Integer to use for tracking the clusters (default = UInt32)
* `seed`            : Seed value for the random number generator (default = 8)
Returns
* `g`               : A new instance of type Lattice2D
Attributes
* `L`               : Side length of the square lattice
* `N`               : Total number of nodes in the lattice, `N = L^2`
* `t`               : Current step in the evolution process, number of edges in the lattice
* `edges`           : Set of edges present in the lattice
* `cluster_ids`     : Array with nodes as indices and cluster IDs as values
* `clusters`        : Dictionary with cluster IDs as keys and clusters as values
* `cluster_sizes`   : Dictionary with cluster sizes as keys and cluster counts as values, i.e. cluster size distribution
* `rng`             : Random number generator
* `observables`     : Custom type containing observables associated with `g`
"""
mutable struct Lattice2D{T <: Integer} <: AbstractLattice
	L               ::Int
	N               ::Int
	t               ::Int
	edges           ::Set{Tuple{T, T}}
	cluster_ids     ::Array{T, 2}
	clusters        ::Dict{T, Set{T}}
	cluster_sizes   ::Dict{T, T}
	rng             ::MersenneTwister
	observables     ::Observables

	function Lattice2D(L::Integer; T::Type{<:Integer}=UInt32, seed::Integer=8)
		N                = L^2
		t                = 0
		edges            = Set()
		cluster_ids      = reshape(collect(UnitRange{T}(1, N)), (L, L))
		clusters         = Dict(UnitRange{T}(1, N) .=> Set.(UnitRange{T}(1, N)))
		cluster_sizes    = Dict(T(1) => T(N))
		rng              = MersenneTwister(seed)
		observables      = Observables()

		new{T}(L,
			N,
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
	Lattice3D(L::Integer; T::Type{<:Integer}=UInt32, seed::Integer=8)

This type represents a 3D lattice in which edges are only allowed to be active between nearest neighbors.
It houses information about the nodes, edges, clusters, and observables.

Arguments
* `L`               : Side length of the cubic lattice
Keyword Arguments
* `T`               : Type of Integer to use for tracking the clusters (default = UInt32)
* `seed`            : Seed value for the random number generator (default = 8)
Returns
* `g`               : A new instance of type Lattice3D
Attributes
* `L`               : Side length of the cubic lattice
* `N`               : Total number of nodes in the lattice, `N = L^3`
* `t`               : Current step in the evolution process, number of edges in the lattice
* `edges`           : Set of edges present in the lattice
* `cluster_ids`     : Array with nodes as indices and cluster IDs as values
* `clusters`        : Dictionary with cluster IDs as keys and clusters as values
* `cluster_sizes`   : Dictionary with cluster sizes as keys and cluster counts as values, i.e. cluster size distribution
* `rng`             : Random number generator
* `observables`     : Custom type containing observables associated with `g`
"""
mutable struct Lattice3D{T <: Integer} <: AbstractLattice
	L               ::Int
	N               ::Int
	t               ::Int
	edges           ::Set{Tuple{T, T}}
	cluster_ids     ::Array{T, 3}
	clusters        ::Dict{T, Set{T}}
	cluster_sizes   ::Dict{T, T}
	rng             ::MersenneTwister
	observables     ::Observables

	function Lattice3D(L::Integer; T::Type{<:Integer}=UInt32, seed::Integer=8)
		N                = L^3
		t                = 0
		edges            = Set()
		cluster_ids      = reshape(collect(UnitRange{T}(1, N)), (L, L, L))
		clusters         = Dict(UnitRange{T}(1, N) .=> Set.(UnitRange{T}(1, N)))
		cluster_sizes    = Dict(T(1) => T(N))
		rng              = MersenneTwister(seed)
		observables      = Observables()

		new{T}(L,
			N,
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
