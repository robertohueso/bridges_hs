-- AUTOR: Roberto Hueso Gómez

module Bridges
  (Tag,
   Coordinates,
   Mundo,
   pintaMundo,
   drawGame,
   check_zero,
   won,
   game1,
   game2,
   game3) where

import Graph
import CodeWorld
import qualified Data.Text as T
import qualified Data.List as L

type Tag = Int
type Coordinates = (Int, Int)
type Mundo = (Graph Tag Int, Coordinates)

-- Transforms Int to Text
intToText :: Int -> T.Text
intToText int = T.pack (show int)

-- Transforms Int coordinates to Double coordinates
coordToD :: (Int, Int) -> (Double, Double)
coordToD (x,y) = (fromIntegral x, fromIntegral y)

-- Given a graph draws its vertices
drawVertices :: Graph Tag Int -> Picture
drawVertices g = pictures (
  [translated
    (fromIntegral a)
    (fromIntegral b)
    (text (intToText t) & circle 0.5)
  | (V t (a,b)) <- (vertices g)]
  )

-- Given a graph draws its edges
drawEdges :: Graph Tag Int -> Picture
drawEdges g = pictures (
  [if (d,o) `elem` (edges g)
   then colored green (thickPath 0.2 [coordToD a, coordToD b])
   else thickPath 0.2 [coordToD a, coordToD b]
  | (o@(V _ a), d@(V _ b)) <- (edges g)]
  )

-- Given a game draws its representation
drawGame :: Graph Tag Int -> Picture
drawGame g =
  drawVertices g &
  drawEdges g

-- Congratulation message
drawWin :: Picture
drawWin = text (T.pack "You won! :D")

-- Draws the current world
pintaMundo :: Mundo -> Picture
pintaMundo m@(g, _) = if won m then drawWin else drawGame g

-- Checks if a game is on its final state.
won :: Mundo -> Bool
won (g, _) = foldr
  (\(V t c) acc -> if t == 0 then True && acc else False)
  True
  (vertices g)

-- Handles user interactions
resuelveEvento :: Event -> Mundo -> Mundo
resuelveEvento (MousePress LeftButton (x,y)) (g, _) = (g, (round x, round y))
resuelveEvento (MousePress MiddleButton (x,y)) (g, o) =
  if not ((origin, dest) `elem` (edges g)) && zero && direction
  then (add_edge (origin, dest) g, o)
  else (g, o)
  where origin = (V 0 o)
        dest = (V 0 (round x, round y))
        zero = check_zero (L.find (==origin) $ vertices g) &&
               check_zero (L.find (==dest) $ vertices g)
        direction = check_direction o (x,y)
resuelveEvento (KeyPress restart_key) _ = main_game
resuelveEvento _ g = g

-- Check if a vertex's tag is not 0
check_zero :: Maybe (Vertex Tag Int) -> Bool
check_zero (Just (V t c)) = t /= 0
check_zero _ = False

-- Check whether an edge is vertical/horizontal
check_direction :: Coordinates -> (Double, Double) -> Bool
check_direction (x,y) (z,w) =
  if x == round z || y == round w then True else False

-- A few example games
game1 :: Graph Tag Int
game1 = add_vertex (V 2 (0, (-3))) (add_vertex (V 2 (0, 0)) empty)

game2 :: Graph Tag Int
game2 =
  add_vertex (V 3 (3, 3)) $
  add_vertex (V 1 (3, 0)) $
  add_vertex (V 5 (0, 3)) $
  add_vertex (V 3 (0, 0)) $
  add_vertex (V 3 (-3, 3)) $
  add_vertex (V 5 (-3, 0)) $
  add_vertex (V 2 (-3, -3)) $
  empty

game3 :: Graph Tag Int
game3 =
  add_vertex (V 1 (3, 3)) $
  add_vertex (V 4 (3, 0)) $
  add_vertex (V 2 (3, -3)) $
  add_vertex (V 2 (0, 3)) $
  add_vertex (V 4 (0, 0)) $
  add_vertex (V 3 (0, -3)) $
  add_vertex (V 3 (-3, 3)) $
  add_vertex (V 2 (-3, 0)) $
  add_vertex (V 1 (-3, -3)) $
  empty

-- Defines global constants
main_game = (game3, undefined)
restart_key = T.pack "Esc"

-- Main program
main :: IO()
main = interactionOf
  main_game
  (\_ e -> e)
  resuelveEvento
  pintaMundo
