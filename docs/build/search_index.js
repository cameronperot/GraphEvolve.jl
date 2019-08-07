var documenterSearchIndex = {"docs":
[{"location":"#GraphEvolve.jl-1","page":"Home","title":"GraphEvolve.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"A Julia package for simulating the evolution of clusters in random networks and lattices.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Check the project out on GitHub!","category":"page"},{"location":"#","page":"Home","title":"Home","text":"This package originated as part of my thesis on explosive percolation.","category":"page"},{"location":"#About-1","page":"Home","title":"About","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"I am currently writing my bachelor's thesis in the computational physics group at Universität Leipzig under the supervision of Prof. Dr. Wolfhard Janke and Dr. Stefan Schnabel. Percolation theory is a subject with a range of applications, and is often used to model phase transitions in physical systems, such as ferromagnets which have an ordered ferromagnetic phase at low temperatures and a disordered phase at high temperatures.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"To be a bit more specific, the topic I am focusing on is explosive percolation, which entails processes where clusters in the graph evolve in such a way that the onset of percolation is delayed until a critical point at which there is a sudden onset of large scale connectivity. I have designed and am in the process of analyzing a model for evaluating and adding edges to a graph called stochastic edge acceptance, or SEA for short.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Illustrated in the plot below (system size n = 10^6) we can see the order parameter C  n plotted against the relative number of edges present in the graph r = t  n where t is the total number of edges present.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"ER = Erdos-Renyi Model\nBF = Bohman-Frieze Model\nPR = Product Rule Model\nSEA = Stochastic Edge Acceptance Model","category":"page"},{"location":"#","page":"Home","title":"Home","text":"(Image: Order Parameter)","category":"page"},{"location":"#","page":"Home","title":"Home","text":"We can see that the BF, PR, and SEA models all exhibit phase transitions at a later point than the reference ER model, which has been proven to transition at r = 05. The PR and SEA models both show a significantly higher rate of change in the order parameter near the critical point.","category":"page"},{"location":"man/getting_started/#Getting-Started-1","page":"Getting Started","title":"Getting Started","text":"","category":"section"},{"location":"man/getting_started/#Installation-1","page":"Getting Started","title":"Installation","text":"","category":"section"},{"location":"man/getting_started/#","page":"Getting Started","title":"Getting Started","text":"To install we just need to clone the repository and point Julia's load path to it. Next time Julia is started GraphEvolve will be available for import.","category":"page"},{"location":"man/getting_started/#","page":"Getting Started","title":"Getting Started","text":"git clone https://github.com/cameronperot/GraphEvolve.jl.git\nexport JULIA_LOAD_PATH=\"$JULIA_LOAD_PATH:$PWD/GraphEvolve.jl/src\"","category":"page"},{"location":"man/getting_started/#Usage-1","page":"Getting Started","title":"Usage","text":"","category":"section"},{"location":"man/getting_started/#","page":"Getting Started","title":"Getting Started","text":"Here's an example of how to instantiate a Network type, evolve it using the stochastic_edge_acceptance! method, and plot the order parameter as a function of the relative number of edges.","category":"page"},{"location":"man/getting_started/#","page":"Getting Started","title":"Getting Started","text":"julia> using GraphEvolve\n\njulia> using Plots; gr(fmt=\"png\")\n\njulia> g = Network(10^6);\n\njulia> stochastic_edge_acceptance!(g, Int(1.5*10^6));\n\njulia> x = collect(0:g.t) ./ g.n;\n\njulia> y = g.observables.largest_cluster_size ./ g.n;\n\njulia> plot_ = plot(dpi=300);\n\njulia> scatter!(x, y,\n           legend=false,\n           marker=(2, :dodgerblue, :circle, 0.9, stroke(0)),\n           xaxis=(latexstring(\"r\"), (0, 1.5), 0:0.5:1.5),\n           yaxis=(latexstring(\"|C|/n\"), (0, 1), 0:0.2:1)\n       );\n\njulia> savefig(plot_, \"/tmp/order_param.png\")","category":"page"},{"location":"man/getting_started/#","page":"Getting Started","title":"Getting Started","text":"This saves the figure:","category":"page"},{"location":"man/getting_started/#","page":"Getting Started","title":"Getting Started","text":"(Image: Order Parameter)","category":"page"},{"location":"man/AbstractGraphs/#Graph-Types-1","page":"Graph Types","title":"Graph Types","text":"","category":"section"},{"location":"man/AbstractGraphs/#","page":"Graph Types","title":"Graph Types","text":"(Image: Custom Types)","category":"page"},{"location":"man/AbstractGraphs/#","page":"Graph Types","title":"Graph Types","text":"AbstractGraph\nAbstractNetwork\nAbstractLattice\nNetwork\nLattice2D\nLattice3D\nObservables","category":"page"},{"location":"man/AbstractGraphs/#GraphEvolve.AbstractGraph","page":"Graph Types","title":"GraphEvolve.AbstractGraph","text":"AbstractGraph\n\nAbstract type\n\nSubtypes\n\nAbstractNetwork\nAbstractLattice\n\n\n\n\n\n","category":"type"},{"location":"man/AbstractGraphs/#GraphEvolve.AbstractNetwork","page":"Graph Types","title":"GraphEvolve.AbstractNetwork","text":"AbstractNetwork\n\nAbstract subtype of AbstractGraph\n\nSubtypes\n\nNetwork\n\n\n\n\n\n","category":"type"},{"location":"man/AbstractGraphs/#GraphEvolve.AbstractLattice","page":"Graph Types","title":"GraphEvolve.AbstractLattice","text":"AbstractLattice\n\nAbstract subtype of AbstractGraph\n\nSubtypes\n\nLattice2D\nLattice3D\n\n\n\n\n\n","category":"type"},{"location":"man/AbstractGraphs/#GraphEvolve.Network","page":"Graph Types","title":"GraphEvolve.Network","text":"Network(n::Int; seed::Int=8)\n\nThis type represents a random network in which edges are allowed to be active between any two of the n nodes. It houses information about the nodes, edges, clusters, and observables.\n\nArguments\n\nn               : Total number of nodes in the network\n\nKeyword Arguments\n\nseed            : Seed value for the random number generator (default = 8)\n\nReturns\n\ng               : A new instance of type Network\n\nAttributes\n\nn               : Total number of nodes in the network\nt               : Current step in the evolution process, number of edges in the network\nedges           : Set of edges present in the network\ncluster_ids     : Array with nodes as indices and cluster IDs as values\nclusters        : Dictionary with cluster IDs as keys and clusters as values\ncluster_sizes   : Dictionary with cluster sizes as keys and cluster counts as values, i.e. cluster size distribution\nrng             : Random number generator\nobservables     : Custom type containing observables associated with g\n\n\n\n\n\n","category":"type"},{"location":"man/AbstractGraphs/#GraphEvolve.Lattice2D","page":"Graph Types","title":"GraphEvolve.Lattice2D","text":"Lattice2D(L::Int; seed::Int=8)\n\nThis type represents a 2D lattice in which edges are only allowed to be active between nearest neighbors. It houses information about the nodes, edges, clusters, and observables.\n\nArguments\n\nL               : Side length of the square lattice\n\nKeyword Arguments\n\nseed            : Seed value for the random number generator (default = 8)\n\nReturns\n\ng               : A new instance of type Lattice2D\n\nAttributes\n\nL               : Side length of the square lattice\nn               : Total number of nodes in the lattice, n = L^2\nt               : Current step in the evolution process, number of edges in the lattice\nedges           : Set of edges present in the lattice\ncluster_ids     : Array with nodes as indices and cluster IDs as values\nclusters        : Dictionary with cluster IDs as keys and clusters as values\ncluster_sizes   : Dictionary with cluster sizes as keys and cluster counts as values, i.e. cluster size distribution\nrng             : Random number generator\nobservables     : Custom type containing observables associated with g\n\n\n\n\n\n","category":"type"},{"location":"man/AbstractGraphs/#GraphEvolve.Lattice3D","page":"Graph Types","title":"GraphEvolve.Lattice3D","text":"Lattice3D(L::Int; seed::Int=8)\n\nThis type represents a 3D lattice in which edges are only allowed to be active between nearest neighbors. It houses information about the nodes, edges, clusters, and observables.\n\nArguments\n\nL               : Side length of the cubic lattice\n\nKeyword Arguments\n\nseed            : Seed value for the random number generator (default = 8)\n\nReturns\n\ng               : A new instance of type Lattice3D\n\nAttributes\n\nL               : Side length of the cubic lattice\nn               : Total number of nodes in the lattice, n = L^3\nt               : Current step in the evolution process, number of edges in the lattice\nedges           : Set of edges present in the lattice\ncluster_ids     : Array with nodes as indices and cluster IDs as values\nclusters        : Dictionary with cluster IDs as keys and clusters as values\ncluster_sizes   : Dictionary with cluster sizes as keys and cluster counts as values, i.e. cluster size distribution\nrng             : Random number generator\nobservables     : Custom type containing observables associated with g\n\n\n\n\n\n","category":"type"},{"location":"man/AbstractGraphs/#GraphEvolve.Observables","page":"Graph Types","title":"GraphEvolve.Observables","text":"Observables\n\nContains the observables associated to a percolation simulation.\n\nAttributes\n\navg_cluster_size     : Array where avg_cluster_size[t] is the average cluster size at step t-1\nheterogeneity        : Array where heterogeneity[t] is the number of unique cluster sizes at step t-1\nlargest_cluster_size : Array where C[t] is the largest cluster size at step t-1\nΔ_method_1           : Tuple (Δ, t₀, t₁), see analysismethods.computeΔmethod1 for more info\nΔ_method_1           : Tuple (Δ, t₀, t₁), see analysismethods.computeΔmethod2 for more info\n\n\n\n\n\n","category":"type"},{"location":"man/evolution_methods/#Evolution-Methods-1","page":"Evolution Methods","title":"Evolution Methods","text":"","category":"section"},{"location":"man/evolution_methods/#","page":"Evolution Methods","title":"Evolution Methods","text":"erdos_renyi!(g::AbstractGraph, n_steps::Int)\nbohman_frieze!(g::AbstractGraph, n_steps::Int; K::Int=2)\nproduct_rule!(g::AbstractGraph, n_steps::Int)\nstochastic_edge_acceptance!(g::AbstractGraph, n_steps::Int)","category":"page"},{"location":"man/evolution_methods/#GraphEvolve.erdos_renyi!-Tuple{AbstractGraph,Int64}","page":"Evolution Methods","title":"GraphEvolve.erdos_renyi!","text":"erdos_renyi!(g::AbstractGraph, n_steps::Int)\n\nErdos-Renyi style graph evolution, adds edges randomly at each step\n\nArguments\n\ng      : An instance of type AbstractGraph\nn_steps: Number of edges to add to the AbstractGraph\n\nReturns\n\nnothing, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/evolution_methods/#GraphEvolve.bohman_frieze!-Tuple{AbstractGraph,Int64}","page":"Evolution Methods","title":"GraphEvolve.bohman_frieze!","text":"bohman_frieze!(g::AbstractGraph, n_steps::Int; K::Int=2)\n\nAchlioptas process, implementation of Bohman-Frieze bounded size rule\n\nArguments\n\ng      : An instance of type AbstractGraph\nn_steps: Number of edges to add to the AbstractGraph\n\nKeyword Arguments\n\nK      : Bounded size of clusters upon which to determine edge acceptance (default = 1)\n\nReturns\n\nnothing, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/evolution_methods/#GraphEvolve.product_rule!-Tuple{AbstractGraph,Int64}","page":"Evolution Methods","title":"GraphEvolve.product_rule!","text":"product_rule!(g::AbstractGraph, n_steps::Int)\n\nAchlioptas process, implementation of the product rule\n\nArguments\n\ng      : An instance of type AbstractGraph\nn_steps: Number of edges to add to the AbstractGraph\n\nReturns\n\nnothing, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/evolution_methods/#GraphEvolve.stochastic_edge_acceptance!-Tuple{AbstractGraph,Int64}","page":"Evolution Methods","title":"GraphEvolve.stochastic_edge_acceptance!","text":"stochastic_edge_acceptance!(g::AbstractGraph, n_steps::Int)\n\nAchlioptas process, a probability based rule for accepting edges\n\nArguments\n\ng      : An instance of type AbstractGraph\nn_steps: Number of edges to add to the AbstractGraph\nq      : Minimum probability that edge₁ is accepted\n\nReturns\n\nnothing, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/edge_methods/#Edge-Methods-1","page":"Edge Methods","title":"Edge Methods","text":"","category":"section"},{"location":"man/edge_methods/#","page":"Edge Methods","title":"Edge Methods","text":"choose_edge(g::Network)\nchoose_edge(g::Lattice2D)\nchoose_edge(g::Lattice3D)\nchoose_edge(g::AbstractGraph, edge₁::Tuple)\nadd_edge!(g::AbstractGraph, edge::Tuple)\nnearest_neighbors(g::Lattice2D, node::Tuple{Int, Int})\nnearest_neighbors(g::Lattice3D, node::Tuple{Int, Int, Int})\ncart_to_lin(cart::Tuple, L::Int)","category":"page"},{"location":"man/edge_methods/#GraphEvolve.choose_edge-Tuple{Network}","page":"Edge Methods","title":"GraphEvolve.choose_edge","text":"choose_edge(g::Network)\n\nRandomly selects an inactive edge in g\n\nArguments\n\ng   : An instance of type Network\n\nReturns\n\nedge: A two-tuple of integers representing an inactive edge in g\n\n\n\n\n\n","category":"method"},{"location":"man/edge_methods/#GraphEvolve.choose_edge-Tuple{Lattice2D}","page":"Edge Methods","title":"GraphEvolve.choose_edge","text":"choose_edge(g::Lattice2D)\n\nRandomly selects an inactive edge in g\n\nArguments\n\ng   : An instance of type Lattice2D\n\nReturns\n\nedge: A two-tuple of two-tuples of integers representing an inactive edge in g\n\n\n\n\n\n","category":"method"},{"location":"man/edge_methods/#GraphEvolve.choose_edge-Tuple{Lattice3D}","page":"Edge Methods","title":"GraphEvolve.choose_edge","text":"choose_edge(g::Lattice3D)\n\nRandomly selects an inactive edge in g\n\nArguments\n\ng   : An instance of type Lattice3D\n\nReturns\n\nedge: A two-tuple of three-tuples of integers representing an inactive edge in g\n\n\n\n\n\n","category":"method"},{"location":"man/edge_methods/#GraphEvolve.choose_edge-Tuple{AbstractGraph,Tuple}","page":"Edge Methods","title":"GraphEvolve.choose_edge","text":"choose_edge(g::AbstractGraph, edge₁::Tuple)\n\nRandomly selects an inactive edge in g that is not equal to edge₁\n\nArguments\n\ng    : An instance of type Lattice2D\nedge₁: A two-tuple of two-tuples of integers representing an inactive edge in g\n\nReturns\n\nedge₂: A two-tuple of two-tuples of integers representing an inactive edge in g\n\n\n\n\n\n","category":"method"},{"location":"man/edge_methods/#GraphEvolve.add_edge!-Tuple{AbstractGraph,Tuple}","page":"Edge Methods","title":"GraphEvolve.add_edge!","text":"add_edge!(g::AbstractGraph, edge::Tuple)\n\nAdds an edge to g\n\nArguments\n\ng   : An instance of type AbstractGraph\nedge: A two-tuple of integers representing the edge to be added to g\n\nReturns\n\nNone, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/edge_methods/#GraphEvolve.nearest_neighbors-Tuple{Lattice2D,Tuple{Int64,Int64}}","page":"Edge Methods","title":"GraphEvolve.nearest_neighbors","text":"nearest_neighbors(g::Lattice2D, node::Tuple{Int, Int})\n\nDetermines the next-nearest neighbors of node\n\nArguments\n\ng        : An instance of type Lattice2D\nnode     : A two-tuple of integers representing a node in g\n\nReturns\n\nneighbors: A four-tuple of two-tuples of integers representing the cartesian indices of the (up, down, left, right) neighbors\n\n\n\n\n\n","category":"method"},{"location":"man/edge_methods/#GraphEvolve.nearest_neighbors-Tuple{Lattice3D,Tuple{Int64,Int64,Int64}}","page":"Edge Methods","title":"GraphEvolve.nearest_neighbors","text":"nearest_neighbors(g::Lattice3D, node::Tuple{Int, Int, Int})\n\nDetermines the next-nearest neighbors of node\n\nArguments\n\ng        : An instance of type Lattice3D\nnode     : A three-tuple of integers representing a node in g\n\nReturns\n\nneighbors: A four-tuple of three-tuples of integers representing the cartesian indices of the (up, down, left, right, front, back) neighbors\n\n\n\n\n\n","category":"method"},{"location":"man/edge_methods/#GraphEvolve.cart_to_lin-Tuple{Tuple,Int64}","page":"Edge Methods","title":"GraphEvolve.cart_to_lin","text":"cart_to_lin(cart::Tuple, L::Int)\n\nConverts d-dimensional Cartesian index (d-tuple) to linear index\n\nArguments\n\ncart : d-Tuple representing Cartesian index, d ∈ {2, 3}\nL    : Linear lattice size\n\nReturns\n\nlin  : Linear index in the lattice corresponding to cart\n\n\n\n\n\n","category":"method"},{"location":"man/cluster_methods/#Cluster-Methods-1","page":"Cluster Methods","title":"Cluster Methods","text":"","category":"section"},{"location":"man/cluster_methods/#","page":"Cluster Methods","title":"Cluster Methods","text":"get_cluster(g::AbstractGraph, node::Int)\nget_largest_cluster_size(g::AbstractGraph)\nget_avg_cluster_size(g::AbstractGraph)\nget_largest_clusters(g::AbstractGraph, n_clusters::Int)\nupdate_clusters!(g::AbstractGraph, edge::Tuple)\nupdate_cluster_sizes!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)\nupdate_cluster_ids!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)\nmerge_clusters!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)\nupdate_observables!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)","category":"page"},{"location":"man/cluster_methods/#GraphEvolve.get_cluster-Tuple{AbstractGraph,Int64}","page":"Cluster Methods","title":"GraphEvolve.get_cluster","text":"get_cluster(g::AbstractGraph, node::Int)\n\nDetermines the cluster in g which node is a member of\n\nArguments\n\ng   : An instance of type AbstractGraph\nnode: Node in keys(g.cluster_ids)\n\nReturns\n\nSet of nodes representing the cluster which node is a member of\n\n\n\n\n\n","category":"method"},{"location":"man/cluster_methods/#GraphEvolve.get_largest_cluster_size-Tuple{AbstractGraph}","page":"Cluster Methods","title":"GraphEvolve.get_largest_cluster_size","text":"get_largest_cluster_size(g::AbstractGraph)\n\nDetermines the size of the largest cluster in g\n\nArguments\n\ng: An instance of type AbstractGraph\n\nReturns\n\nInteger representing the number of nodes in the largest cluster in g\n\n\n\n\n\n","category":"method"},{"location":"man/cluster_methods/#GraphEvolve.get_avg_cluster_size-Tuple{AbstractGraph}","page":"Cluster Methods","title":"GraphEvolve.get_avg_cluster_size","text":"get_avg_cluster_size(g::AbstractGraph)\n\nDetermines the average cluster size in g\n\nArguments\n\ng: An instance of type AbstractGraph\n\nReturns\n\nFloat64 representing the average cluster size in g\n\n\n\n\n\n","category":"method"},{"location":"man/cluster_methods/#GraphEvolve.get_largest_clusters-Tuple{AbstractGraph,Int64}","page":"Cluster Methods","title":"GraphEvolve.get_largest_clusters","text":"get_largest_clusters(g::AbstractGraph, n_clusters::Int)\n\nDetermines the n_clusters largest clusters in 'g'\n\nArguments\n\ng         : An instance of type AbstractGraph\nn_clusters: The number of largest clusters to return\n\nReturns\n\nSorted (descending) array of the n_clusters largest clusters in g\n\n\n\n\n\n","category":"method"},{"location":"man/cluster_methods/#GraphEvolve.update_clusters!-Tuple{AbstractGraph,Tuple}","page":"Cluster Methods","title":"GraphEvolve.update_clusters!","text":"update_clusters!(g::AbstractGraph, edge::Tuple)\n\nUpdates g with the newly merged cluster and the largest cluster size Arguments\n\ng   : An instance of type AbstractGraph\nedge: Edge added to g at step g.t\n\nReturns\n\nNone, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/cluster_methods/#GraphEvolve.update_cluster_sizes!-Tuple{AbstractGraph,Int64,Int64}","page":"Cluster Methods","title":"GraphEvolve.update_cluster_sizes!","text":"update_cluster_sizes!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)\n\nUpdates the cluster size distribution dictionary\n\nArguments\n\ng                 : An instance of type AbstractGraph\nlarger_cluster_id : Cluster ID of the larger cluster\nsmaller_cluster_id: Cluster ID of the smaller cluster\n\nReturns\n\nNone, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/cluster_methods/#GraphEvolve.update_cluster_ids!-Tuple{AbstractGraph,Int64,Int64}","page":"Cluster Methods","title":"GraphEvolve.update_cluster_ids!","text":"update_cluster_ids!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)\n\nUpdates the cluster IDs of the nodes in the smaller cluster to that of the larger cluster it is being merged into\n\nArguments\n\ng                 : An instance of type AbstractGraph\nlarger_cluster_id : Cluster ID of the larger cluster\nsmaller_cluster_id: Cluster ID of the smaller cluster\n\nReturns\n\nNone, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/cluster_methods/#GraphEvolve.merge_clusters!-Tuple{AbstractGraph,Int64,Int64}","page":"Cluster Methods","title":"GraphEvolve.merge_clusters!","text":"merge_clusters!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)\n\nMergers the smaller cluster into the larger cluster in-place\n\nArguments\n\ng                 : An instance of type AbstractGraph\nlarger_cluster_id : Cluster ID of the larger cluster\nsmaller_cluster_id: Cluster ID of the smaller cluster\n\nReturns\n\nNone, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/cluster_methods/#GraphEvolve.update_observables!-Tuple{AbstractGraph,Int64,Int64}","page":"Cluster Methods","title":"GraphEvolve.update_observables!","text":"update_observables!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)\n\nUpdates the largest cluster size, average cluster size, and cluster heterogeneity\n\nArguments\n\ng                 : An instance of type AbstractGraph\nlarger_cluster_id : Cluster ID of the larger cluster\nsmaller_cluster_id: Cluster ID of the smaller cluster\n\nReturns\n\nNone, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/analysis_methods/#Analysis-Methods-1","page":"Analysis Methods","title":"Analysis Methods","text":"","category":"section"},{"location":"man/analysis_methods/#","page":"Analysis Methods","title":"Analysis Methods","text":"compute_Δ_method_1!(g::AbstractGraph)\ncompute_Δ_method_2!(g::AbstractGraph)\nfinalize_observables!(g::AbstractGraph)","category":"page"},{"location":"man/analysis_methods/#GraphEvolve.compute_Δ_method_1!-Tuple{AbstractGraph}","page":"Analysis Methods","title":"GraphEvolve.compute_Δ_method_1!","text":"compute_Δ_method_1!(g::AbstractGraph)\n\nDetermines Δ, t₀, and t₁ for the given evolved g\n\nArguments\n\ng : An evolved instance of type AbstractGraph\n\nExtra Information\n\nΔ : t₁ - t₀\nt₀: The last step in the evolution process satisfying g.observables.largest_cluster_size < sqrt(g.n)\nt₁: The first step in the evolution process satisfying g.observables.largest_cluster_size > 0.5g.n\n\nReturns\n\nNone, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/analysis_methods/#GraphEvolve.compute_Δ_method_2!-Tuple{AbstractGraph}","page":"Analysis Methods","title":"GraphEvolve.compute_Δ_method_2!","text":"compute_Δ_method_2!(g::AbstractGraph)\n\nDetermines Δ, t₀, and t₁ for the given evolved g\n\nArguments\n\ng : An evolved instance of type AbstractGraph\n\nExtra Information\n\nΔ : t₁ - t₀\nt₀: The step in the evolution process where the heterogeneity peaks\nt₁: The step in the evolution process where the size of the largest cluster increases the most\n\nReturns\n\nNone, updates g in-place\n\n\n\n\n\n","category":"method"},{"location":"man/analysis_methods/#GraphEvolve.finalize_observables!-Tuple{AbstractGraph}","page":"Analysis Methods","title":"GraphEvolve.finalize_observables!","text":"finalize_observables!(g::AbstractGraph)\n\nFinalize the observables for the given evolved g\n\nArguments\n\ng : An evolved instance of type AbstractGraph\n\nReturns\n\nNone, updates g in-place\n\n\n\n\n\n","category":"method"}]
}
