import Graph
import CodeWorld
import qualified Data.Text as T

type Tag = Int
type Coordinates = (Int, Int)
type Mundo = (Graph Tag Int, Coordinates, Coordinates)

intToText :: Int -> T.Text
intToText int = T.pack (show int)

coordToD :: (Int, Int) -> (Double, Double)
coordToD (x,y) = (fromIntegral x, fromIntegral y)

drawVertices :: Graph Tag Int -> Picture
drawVertices g = pictures (
  [translated
    (fromIntegral a)
    (fromIntegral b)
    (text (intToText t) & circle 0.5)
  | (V t (a,b)) <- (vertices g)]
  )

drawEdges :: Graph Tag Int -> Picture
drawEdges g = pictures (
  [thickPath 0.2 [coordToD a, coordToD b] | (V _ a, V _ b) <- (edges g)]
  )

drawGame :: Graph Tag Int -> Picture
drawGame g =
  drawVertices g &
  drawEdges g

drawWin :: Picture
drawWin = text (T.pack "You won! :D")

pintaMundo :: Mundo -> Picture
pintaMundo m@(g, _, _) = if won m then drawWin else drawGame g

won :: Mundo -> Bool
won (g, _, _) = foldr
  (\(V t c) acc -> if t == 0 then True && acc else False)
  True
  (vertices g)

resuelveEvento :: Event -> Mundo -> Mundo
resuelveEvento (MousePress LeftButton (x,y)) (g, o, d) = (g, (round x, round y), d)
resuelveEvento (MousePress MiddleButton (x,y)) (g, o, d) =
  (add_edge ((V 0 o),(V 0 (round x, round y))) g, o, d)
resuelveEvento _ g = g

main :: IO()
main = interactionOf
  (game3, undefined, undefined)
  (\_ e -> e)
  resuelveEvento
  pintaMundo

game1 :: Graph Tag Int
game1 = add_vertex (V 2 (0, (-3))) (add_vertex (V 2 (0, 3)) empty)

game2 :: Graph Tag Int
game2 =
  add_vertex (V 3 (2, 3)) $
  add_vertex (V 1 (2, 0)) $
  add_vertex (V 5 (0, 3)) $
  add_vertex (V 3 (0, 0)) $
  add_vertex (V 3 (-2, 3)) $
  add_vertex (V 5 (-2, 0)) $
  add_vertex (V 2 (-2, -3)) $
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
