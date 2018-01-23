-- AUTOR: Roberto Hueso Gómez

import Bridges
import Graph
import CodeWorld
import qualified Data.List as L

type Estado = Graph Tag Int

-- Varios estados iniciales
estado1 = game1
estado2 = game2
estado3 = game3

-- Comprueba si un estado es final
esEstadoFinal :: Estado -> Bool
esEstadoFinal g = foldr
  (\(V t _) acc -> if t == 0 then True && acc else False)
  True
  (vertices g)

-- Movimiento: Dirección (Vertice seleccionado)
data Movimiento = Arriba (Vertex Tag Int)
  | Abajo (Vertex Tag Int)
  | Izquierda (Vertex Tag Int)
  | Derecha (Vertex Tag Int)

-- Comprueba que movimientos son aplicables a cada estado
aplicables :: Estado -> [Movimiento]
aplicables g = [mov | mov <- movs, (posible g mov)]
  where movs = concat [[Arriba v, Abajo v, Izquierda v, Derecha v]
               | v <- vertices g]

-- Comprueba si tiene sentio aplicar un moimiento a un estado
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
        
-- Aplica un movimiento a un estado
aplica :: Movimiento -> Estado -> Estado
aplica (Arriba v@(V t (x,y))) g = add_edge (v, dest) g
  where dest = (V 0 (x,y+3))
aplica (Abajo v@(V t (x,y))) g = add_edge (v, dest) g
  where dest = (V 0 (x,y-3))
aplica (Izquierda v@(V t (x,y))) g = add_edge (v, dest) g
  where dest = (V 0 (x-3,y))
aplica (Derecha v@(V t (x,y))) g = add_edge (v, dest) g
  where dest = (V 0 (x+3,y))

-- Genera el recorrido en anchura del arbol de búsqueda.
genera_anchura :: [Estado] -> [Estado]
genera_anchura [] = []
genera_anchura es = [e | e <- es] ++
  genera_anchura (concat [[aplica m e | m <- aplicables e] | e <- es])

-- Otra idea de recorrido en anchura (?)
-- genera_anchura :: Estado -> [Estado]
-- genera_anchura g = res ++ (concat [genera_anchura r | r <- res])
--  where res = [aplica m g | m <- aplicables g]

-- Busca una solución en el arbol de búsqueda.
busqueda :: Estado -> Maybe Estado
-- busqueda g = L.find (esEstadoFinal) (genera_anchura g)
busqueda e = L.find (esEstadoFinal) (genera_anchura [e])

-- Dibuja en CodeWorld un estado
dibuja_resultado :: Maybe Estado -> IO()
dibuja_resultado (Just e) = drawingOf $ drawGame e
dibuja_estado _ = drawingOf blank
