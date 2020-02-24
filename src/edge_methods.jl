"""
	choose_edge(g::Network)

Randomly selects an inactive edge in `g`

Arguments
* `g`   : An instance of type Network
Returns
* `edge`: A two-tuple of integers representing an inactive edge in `g`
"""
function choose_edge(g::Network)
	node_ids = UnitRange{eltype(g.cluster_ids)}(1, g.N)
	edge     = (rand(g.rng, node_ids), rand(g.rng, node_ids))

	if edge[1] ≠ edge[2] && edge ∉ g.edges && reverse(edge) ∉ g.edges
		return edge
	else
		choose_edge(g)
	end
end


"""
	choose_edge(g::Lattice2D)

Randomly selects an inactive edge in `g`

Arguments
* `g`   : An instance of type Lattice2D
Returns
* `edge`: A two-tuples of integers representing an inactive edge in `g`
"""
function choose_edge(g::Lattice2D)
	node_ids = UnitRange{eltype(g.cluster_ids)}(1, g.L)
	node     = (rand(g.rng, node_ids), rand(g.rng, node_ids))
	neighbor = nearest_neighbors(g, node)[rand(g.rng, 1:4)]
	edge     = (cart_to_lin(node, g.L), cart_to_lin(neighbor, g.L))

	if edge ∉ g.edges && reverse(edge) ∉ g.edges
		return edge
	else
		choose_edge(g)
	end
end


"""
	choose_edge(g::Lattice3D)

Randomly selects an inactive edge in `g`

Arguments
* `g`   : An instance of type Lattice3D
Returns
* `edge`: A two-tuple of integers representing an inactive edge in `g`
"""
function choose_edge(g::Lattice3D)
	node     = (rand(g.rng, 1:g.L), rand(g.rng, 1:g.L), rand(g.rng, 1:g.L))
	neighbor = nearest_neighbors(g, node)[rand(g.rng, 1:6)]
	edge     = (cart_to_lin(node, g.L), cart_to_lin(neighbor, g.L))

	if edge ∉ g.edges && reverse(edge) ∉ g.edges
		return edge
	else
		choose_edge(g)
	end
end


"""
	choose_edge(g::AbstractGraph, edge₁::NTuple{2, Integer})

Randomly selects an inactive edge in `g` that is not equal to `edge₁`

Arguments
* `g`    : An instance of type AbstractGraph
* `edge₁`: A two-tuple of integers representing an inactive edge in `g`
Returns
* `edge₂`: A two-tuple of integers representing an inactive edge in `g` not equal to `edge₁`
"""
function choose_edge(g::AbstractGraph, edge₁::NTuple{2, Integer})
	edge₂ = choose_edge(g)

	if edge₂ ≠ edge₁ && edge₂ ≠ reverse(edge₁)
		return edge₂
	else
		choose_edge(g, edge₁)
	end
end


"""
	choose_edge(g::AbstractGraph, edges::Array{NTuple{2, Integer}, 1})

Randomly selects an inactive edge in `g` that is not equal to `edge₁`

Arguments
* `g`    : An instance of type AbstractGraph
* `edges`: An array of two-tuples of integers representing inactive edges in `g`
Returns
* `edge`: A two-tuple of integers representing an inactive edge in `g` not in `edges`
"""
function choose_edge(g::AbstractGraph, edges::Array{NTuple{2, Integer}, 1})
	edge = choose_edge(g)

	if edge ∉ edges && reverse(edge) ∉ edges
		return edge
	else
		choose_edge(g, edges)
	end
end


"""
	add_edge!(g::AbstractGraph, edge::NTuple{2, Integer})

Adds an edge to `g`

Arguments
* `g`   : An instance of type AbstractGraph
* `edge`: A two-tuple of integers representing the edge to be added to `g`
Returns
* None, updates `g` in-place
"""
function add_edge!(g::AbstractGraph, edge::NTuple{2, Integer})
	push!(g.edges, edge)
	g.t += 1
	update_clusters!(g, edge)
end


"""
Functions below this point are for determining nearest-neighbors with periodic boundary conditions in hyper-cubic lattices and converting the indices from Cartesian to linear
"""


"""
`plus` and `minus` are an implementation of periodic boundary conditions for use in the `nearest_neighbors` functions below
"""
function plus(L::Integer, i::Integer)
	i == L ? 1 : i+1
end
function minus(L::Integer, i::Integer)
	i == 1 ? L : i-1
end


"""
	nearest_neighbors(g::Lattice2D, node::NTuple{2, Integer})

Determines the nearest neighbors of `node`

Arguments
* `g`        : An instance of type Lattice2D
* `node`     : A two-tuple of integers representing a node in `g`
Returns
* `neighbors`: A four-tuple of two-tuples of integers representing the cartesian indices of the (up, down, left, right) neighbors
"""
function nearest_neighbors(g::Lattice2D, node::NTuple{2, Integer})
	return ((minus(g.L, node[1]), node[2]),
			(plus(g.L, node[1]), node[2]),
			(node[1], minus(g.L, node[2])),
			(node[1], plus(g.L, node[2])))
end


"""
	nearest_neighbors(g::Lattice3D, node::NTuple{3, Integer})

Determines the nearest neighbors of `node`

Arguments
* `g`        : An instance of type Lattice3D
* `node`     : A three-tuple of integers representing a node in `g`
Returns
* `neighbors`: A four-tuple of three-tuples of integers representing the cartesian indices of the (up, down, left, right, front, back) neighbors
"""
function nearest_neighbors(g::Lattice3D, node::NTuple{3, Integer})
	return ((minus(g.L, node[1]), node[2], node[3]),
			(plus(g.L, node[1]), node[2], node[3]),
			(node[1], minus(g.L, node[2]), node[3]),
			(node[1], plus(g.L, node[2]), node[3]),
			(node[1], node[2], minus(g.L, node[3])),
			(node[1], node[2], plus(g.L, node[3])))
end


"""
	cart_to_lin(cart::Tuple, L::Integer)

Converts d-dimensional Cartesian index (d-tuple) to linear index

Arguments
* `cart` : d-Tuple representing Cartesian index, d ∈ {2, 3}
* `L`    : Linear lattice size
Returns
* `lin`  : Linear index in the lattice corresponding to cart
"""
function cart_to_lin(cart::Tuple, L::Integer)
	if length(cart) == 2
		return (cart[2] - 1) * L + cart[1]
	elseif length(cart) == 3
		return (cart[3] - 1) * L^2 + (cart[2] - 1) * L + cart[1]
	end
end
