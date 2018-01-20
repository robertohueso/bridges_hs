import Graph
import CodeWorld
import qualified Data.Text as T

type Tag = T.Text

drawVertices :: Graph Tag Double -> Picture
drawVertices g = pictures (
  [translated a b (text t & circle 0.5) | (V t (a,b)) <- (vertices g)]
  )

drawGame :: Graph Tag Double -> Picture
drawGame g =
  drawVertices g &
  coordinatePlane

main :: IO()
main = drawingOf (drawGame game1)
game1 :: Graph Tag Double
game1 = add_vertex (V (T.pack "a") (5.0,4.0)) empty
