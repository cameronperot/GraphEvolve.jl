"""
	choose_edge(g::Network)

Randomly selects an inactive edge in `g`

Arguments
* `g`   : An instance of type Network
Returns
* `edge`: A two-tuple of integers representing an inactive edge in `g`
"""
function choose_edge(g::Network)
	edge = (rand(g.rng, 1:g.n), rand(g.rng, 1:g.n))

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
* `edge`: A two-tuple of two-tuples of integers representing an inactive edge in `g`
"""
function choose_edge(g::Lattice2D)
	node     = (rand(g.rng, 1:g.L), rand(g.rng, 1:g.L))
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
* `edge`: A two-tuple of three-tuples of integers representing an inactive edge in `g`
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
	choose_edge(g::AbstractGraph, edge₁::Tuple)

Randomly selects an inactive edge in `g` that is not equal to `edge₁`

Arguments
* `g`    : An instance of type Lattice2D
* `edge₁`: A two-tuple of two-tuples of integers representing an inactive edge in `g`
Returns
* `edge₂`: A two-tuple of two-tuples of integers representing an inactive edge in `g`
"""
function choose_edge(g::AbstractGraph, edge₁::Tuple)
	edge₂ = choose_edge(g)

	if edge₂ ≠ edge₁ && edge₂ ≠ reverse(edge₁)
		return edge₂
	else
		choose_edge(g, edge₁)
	end
end


"""
	add_edge!(g::AbstractGraph, edge::Tuple)

Adds an edge to `g`

Arguments
* `g`   : An instance of type AbstractGraph
* `edge`: A two-tuple of integers representing the edge to be added to `g`
Returns
* None, updates `g` in-place
"""
function add_edge!(g::AbstractGraph, edge::Tuple)
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
function plus(L::Int, i::Int)
	i == L ? 1 : i+1
end
function minus(L::Int, i::Int)
	i == 1 ? L : i-1
end


"""
	nearest_neighbors(g::Lattice2D, node::Tuple{Int, Int})

Determines the next-nearest neighbors of `node`

Arguments
* `g`        : An instance of type Lattice2D
* `node`     : A two-tuple of integers representing a node in `g`
Returns
* `neighbors`: A four-tuple of two-tuples of integers representing the cartesian indices of the (up, down, left, right) neighbors
"""
function nearest_neighbors(g::Lattice2D, node::Tuple{Int, Int})
	return ((minus(g.L, node[1]), node[2]),
			(plus(g.L, node[1]), node[2]),
			(node[1], minus(g.L, node[2])),
			(node[1], plus(g.L, node[2])))
end


"""
	nearest_neighbors(g::Lattice3D, node::Tuple{Int, Int, Int})

Determines the next-nearest neighbors of `node`

Arguments
* `g`        : An instance of type Lattice3D
* `node`     : A three-tuple of integers representing a node in `g`
Returns
* `neighbors`: A four-tuple of three-tuples of integers representing the cartesian indices of the (up, down, left, right, front, back) neighbors
"""
function nearest_neighbors(g::Lattice3D, node::Tuple{Int, Int, Int})
	return ((minus(g.L, node[1]), node[2], node[3]),
			(plus(g.L, node[1]), node[2], node[3]),
			(node[1], minus(g.L, node[2]), node[3]),
			(node[1], plus(g.L, node[2]), node[3]),
			(node[1], node[2], minus(g.L, node[3])),
			(node[1], node[2], plus(g.L, node[3])))
end


"""
	cart_to_lin(cart::Tuple, L::Int)

Converts d-dimensional Cartesian index (d-tuple) to linear index

Arguments
* `cart` : d-Tuple representing Cartesian index, d ∈ {2, 3}
* `L`    : Linear lattice size
Returns
* `lin`  : Linear index in the lattice corresponding to cart
"""
function cart_to_lin(cart::Tuple, L::Int)
	if length(cart) == 2
		return (cart[2] - 1) * L + cart[1]
	elseif length(cart) == 3
		return (cart[3] - 1) * L^2 + (cart[2] - 1) * L + cart[1]
	end
end
