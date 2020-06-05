path = "/home/user/programming/GraphEvolve.jl/src/"
push!(LOAD_PATH, path)
using Documenter, GraphEvolve

makedocs(sitename = "GraphEvolve.jl",
	authors = "Cameron Perot",
	pages = [
		"Home" => "index.md"
		"Manual" => Any[
			"man/getting_started.md",
			# "man/examples.md",
			"man/AbstractGraphs.md",
			"man/evolution_methods.md",
			"man/edge_methods.md",
			"man/cluster_methods.md",
			"man/analysis_methods.md"
		]
	]
)
