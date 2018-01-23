module Graph
  (Vertex(..),
   Edge,
   Graph,
   empty,
   vertices,
   edges,
   valid_edge,
   add_vertex,
   add_edge) where

data Vertex tag coord = V tag (coord, coord)
-- Vertex a == vertex b if their coordinates are the same.
instance (Eq c, Num c, Num t) => Eq (Vertex t c) where
  V a (x,y) == V b (z,w) = x==z && y==w
  a /= b = not (a==b)
instance (Show c, Show t) => Show (Vertex t c) where
  show (V t c) = show c

-- Directed edges from one vertex to another are represente by a tuple
-- (origin_vertex, destination_vertex)
type Edge t c = (Vertex t c, Vertex t c)

-- Graphs can be empty or have vertices
data Graph t c = Empty | G (Vertex t c) [(Vertex t c)] (Graph t c)
  deriving Show

-- Empty graph
empty :: Graph t c
empty = Empty

-- List of graph's vertices
vertices :: Graph t c -> [Vertex t c]
vertices Empty = []
vertices (G v _ g) = [v] ++ (vertices g)

-- List of graph's edges
edges :: Graph t c -> [Edge t c]
edges (G a vs g) = [(a, b) | b <- vs] ++ (edges g)
edges _ = []

-- Test if an edge is a cycle on the same vertex
valid_edge :: (Eq c) => Edge t c -> Bool
valid_edge ((V _ a), (V _ b)) = a /= b

-- Add a vertex to the graph
add_vertex :: (Eq c) => Vertex t c -> Graph t c -> Graph t c
add_vertex vertex g = G vertex [] g

-- Add an edge to the graph
add_edge :: (Eq c, Num c, Num t) => Edge t c -> Graph t c -> Graph t c
add_edge _ Empty = Empty
add_edge (origin,dest) (G (V t v) vs g)
  | (V t v) == origin && valid_edge (origin, dest) && not (dest `elem` vs)=
    G (V (t-1) v) (dest:vs) (add_edge (origin,dest) g)
  | (V t v) == dest && valid_edge (origin, dest) =
    G (V (t-1) v) vs (add_edge (origin,dest) g)
  | otherwise = G (V t v) vs (add_edge (origin,dest) g)
