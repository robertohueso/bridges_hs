import Bridges
import Graph
import CodeWorld
import qualified Data.List as L

type Estado = Graph Tag Int

estado1 = game1
estado2 = game2
estado3 = game3

esEstadoFinal :: Estado -> Bool
esEstadoFinal g = foldr
  (\(V t _) acc -> if t == 0 then True && acc else False)
  True
  (vertices g)

data Movimiento = Arriba (Vertex Tag Int)
  | Abajo (Vertex Tag Int)
  | Izquierda (Vertex Tag Int)
  | Derecha (Vertex Tag Int)

aplicables :: Estado -> [Movimiento]
aplicables g = [mov | mov <- movs, (posible g mov)]
  where movs = concat [[Arriba v, Abajo v, Izquierda v, Derecha v]
               | v <- vertices g]

posible :: Estado -> Movimiento -> Bool
posible g (Arriba or@(V t (x,y))) = v_find /= Nothing && e_find == Nothing
  where verts = vertices g
        edgs = edges g
        dest = (V 0 (x,y+3))
        v_find = L.find (==dest) verts
        e_find = L.find (==(or,dest)) edgs
posible g (Abajo or@(V t (x,y))) = v_find /= Nothing && e_find == Nothing
  where verts = vertices g
        edgs = edges g
        dest = (V 0 (x,y-3))
        v_find = L.find (==dest) verts
        e_find = L.find (==(or,dest)) edgs
posible g (Izquierda or@(V t (x,y))) = v_find /= Nothing && e_find == Nothing
  where verts = vertices g
        edgs = edges g
        dest = (V 0 (x-3,y))
        v_find = L.find (==dest) verts
        e_find = L.find (==(or,dest)) edgs
posible g (Derecha or@(V t (x,y))) = v_find /= Nothing && e_find == Nothing
  where verts = vertices g
        edgs = edges g
        dest = (V 0 (x+3,y))
        v_find = L.find (==dest) verts
        e_find = L.find (==(or,dest)) edgs
        

aplica :: Movimiento -> Estado -> Estado
aplica (Arriba v@(V t (x,y))) g = add_edge (v, dest) g
  where dest = (V 0 (x,y+3))
aplica (Abajo v@(V t (x,y))) g = add_edge (v, dest) g
  where dest = (V 0 (x,y-3))
aplica (Izquierda v@(V t (x,y))) g = add_edge (v, dest) g
  where dest = (V 0 (x-3,y))
aplica (Derecha v@(V t (x,y))) g = add_edge (v, dest) g
  where dest = (V 0 (x+3,y))

genera_anchura :: Estado -> [Estado]
genera_anchura g = res ++ (concat [genera_anchura r | r <- res])
  where res = [aplica m g | m <- aplicables g]

busqueda :: Estado -> Maybe Estado
busqueda g = L.find (esEstadoFinal) (genera_anchura g)

dibuja_resultado :: Maybe Estado -> IO()
dibuja_resultado (Just e) = drawingOf $ drawGame e
dibuja_estado _ = drawingOf blank
