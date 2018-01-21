module Graph
  (Vertex(..),
   Edge,
   Graph,
   empty,
   vertices,
   edges,
   valid_edge,
   add_vertex) where

-- Directed edges from one vertex to another are represente by a tuple
-- (origin_vertex, destination_vertex)
data Vertex tag coord = V tag (coord, coord)
instance (Eq c) => Eq (Vertex t c) where
  V a (x,y) == V b (z,w) = x==z && y==w

type Edge t c = (Vertex t c, Vertex t c)

-- Graphs can be empty, have a single vertex or multiple vertices
-- all with some coordiantes and a tag.
data Graph t c = Empty | G (Vertex t c) [(Vertex t c)] (Graph t c)

-- Empty graph
empty :: Graph t c
empty = Empty

-- List of graph's vertices
vertices :: Graph t c -> [Vertex t c]
vertices Empty = []
vertices (G v _ g) = [v] ++ (vertices g)

-- List of edges
edges :: Graph t c -> [Edge t c]
edges (G a vs g) = [(a, b) | b <- vs] ++ (edges g)
edges _ = []

-- Test if an edge is a cycle on the same vertex
valid_edge :: (Eq c) => Edge t c -> Bool
valid_edge ((V _ a), (V _ b)) = a /= b

-- Add a vertex to the graph
add_vertex :: (Eq c) => Vertex t c -> Graph t c -> Graph t c
add_vertex vertex g = G vertex [] g

add_edge :: (Eq c) => Edge t c -> Graph t c -> Graph t c
add_edge _ Empty = Empty
add_edge (origin,destination) (G v vs g) =
  if v == origin && valid_edge (origin, destination)
  then G v (destination:vs) g
  else G v vs (add_edge (origin,destination) g)
