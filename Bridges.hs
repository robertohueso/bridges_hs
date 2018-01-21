import Graph
import CodeWorld
import qualified Data.Text as T

type Tag = Int

intToText :: Int -> T.Text
intToText int = T.pack (show int)

drawVertices :: Graph Tag Double -> Picture
drawVertices g = pictures (
  [translated a b (text (intToText t) & circle 0.5) | (V t (a,b)) <- (vertices g)]
  )

drawGame :: Graph Tag Double -> Picture
drawGame g =
  drawVertices g &
  coordinatePlane

handleEvent :: Event -> Graph Tag Double -> Graph Tag Double
handleEvent (MousePress LeftButton (x,y)) g
  | x == 0 || y == 0 = add_vertex (V 3 (1,1)) g
  | otherwise = g
handleEvent _ g = g

main :: IO()
main = interactionOf game1 (\_ e -> e) handleEvent drawGame
game1 :: Graph Tag Double
game1 = add_vertex (V 2 (0, (-3))) (add_vertex (V 2 (0, 3)) empty)
