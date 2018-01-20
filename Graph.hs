module Graph
  (Edge,
   Graph,
   empty,
   vertices,
   edges,
   valid_edge,
   add_vertex) where

-- Directed edges from one vertex to another are represente by a tuple
-- (origin, destination)
type Edge p = (p, p)

-- Graphs can be empty, have a single vertex or multiple vertices
-- all with some coordiantes and a tag.
data Graph t p = Empty | V t p | G t p [p] (Graph t p)

-- Empty graph
empty :: Graph t p
empty = Empty

-- List of graph's vertices
vertices :: Graph t p -> [p]
vertices Empty = []
vertices (V t p) = [p]
vertices (G t p _ g) = [p] ++ (vertices g)

-- List of edges
edges :: (Eq p) => Graph t p -> [Edge p]
edges (G t p ps g) = [(p, v) | v <- ps] ++ (edges g)
edges _ = []

-- Test if an edge is a cycle on the same vertex
valid_edge :: (Eq p) => Edge p -> Bool
valid_edge (a, b) = a /= b

-- Add a vertex to the graph
add_vertex :: (Eq p) => t -> p -> Graph t p -> Graph t p
add_vertex t p Empty = V t p
add_vertex t p g = G t p [] g
