import Bridges
import Graph

type Estado = (Graph Tag Int, Vertex Tag Int)

estado1 = (game1, undefined)
estado2 = (game2, undefined)
estado3 = (game3, undefined)

esEstadoFinal :: Estado -> Bool
esEstadoFinal (g, _) = foldr
  (\(V t _) acc -> if t == 0 then True && acc else False)
  True
  (vertices g)

data Movimiento = Arriba (Vertex Tag Int)
  | Abajo (Vertex Tag Int)
  | Izquierda (Vertex Tag Int)
  | Derecha (Vertex Tag Int)

aplicables :: Estado -> [Movimiento]
aplicables e = undefined

aplica :: Movimiento -> Estado -> Estado
aplica m e = undefined
