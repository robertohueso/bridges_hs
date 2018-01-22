import Bridges
import Graph

type Estado = Graph Tag Int

estado1 = game1
estado2 = game2
estado3 = game3

esEstadoFinal :: Estado -> Bool
esEstadoFinal e = undefined

data Movimiento = Arriba (Vertex Tag Int)
  | Abajo (Vertex Tag Int)
  | Izquierda (Vertex Tag Int)
  | Derecha (Vertex Tag Int)

aplicables :: Estado -> [Movimiento]
aplicables e = undefined

aplica :: Movimiento -> Estado -> Estado
aplica m e = undefined
