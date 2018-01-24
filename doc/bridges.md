---
title: Bridges
authors: Roberto Hueso Gómez
left-header: Programación Declarativa
right-header: \today
---

# Descripción
El puzle consiste en varias islas que se pueden conectar entre ellas
por puentes.
Dadas dos islas, se pueden conectar entre ellas por 0, 1 o 2 puentes.
Cada isla tiene asociado un número $x \in \mathbb{N}$ y cada vez que
conectamos un puente a esa isla $x_n=x_{n-1}-1$ el objetivo es
hacer que $x_n=0$ en todas las islas.
Cuando cumplimos el objetivo, hemos ganado la partida.

\begin{figure}[H]
    \caption{Captura de pantalla durante el juego.}
    \begin{center}
    \includegraphics[height=10cm]{./img/screenshot_1.jpg}
    \end{center}
\end{figure}

# Representación
Todo el problema se ha representado como un grafo dirigido en el que
los vértices son las islas y las aristas los puentes.

Obviaré los detalles del código puesto que para algo detallado
es mas simple leer el código.

## Grafo
El grafo se define como
```haskell
data Graph = Empty | G vertice [vertices_conectados] (Graph)
```
Dónde *vertice* se define como
```haskell
data Vertex = V etiqueta (x, y)
```
Donde la *etiqueta* es el número asociado a la isla y (x,y) son las
coordenadas x,y en el plano euclideo de la isla.
El campo *vertices_conectados* indican los vertices a los que se
conecta *vertice* de manera que queda representado la arista dirigida
*vertice*$\rightarrow$*vertice_conectado_1*

El tipo arista es puramente auxiliar y se define como
```haskell
type Edge = (vertice_origen, vertice_destino)
```
## Juego
He decidido que la *etiqueta* de los nodos sea un entero (los puentes
restantes) por simplicidad. Los nodos estarán en puntos discretos
del plano, por lo que he decidido que las *coordenadas* se expresen
como duplas de enteros.
```haskell
type Coordinates = (Int, Int)
```
El tipo *Mundo* también será una dupla pero en este caso será entre
un grafo y unas coordenadas (como método auxiliar) que representan
las coordenadas de origen de la arista. Las coordenadas de destino las
tomaremos en el manejador de acciones.
```haskell
type Mundo = (Graph, Coordinates)
```
Para simplificar el código al crear los grafos haré las coordenadas
(x,y) de los nodos sean múltiplos de 3 partiendo del origen (0,0).
También haré que los puentes no se puedan cruzar para evitar tener que
comprobar la planaridad del grafo.

## Búsqueda de solución en anchura
El tipo *Estado* quedará definido como
```haskell
type Estado = Graph
```
Dónde *Graph* representa el estado actual del mapa de islas.

Los movimientos que podremos aplicar a cada situación del mapa vendrán
determinados por *Movimiento* que se define como
```haskell
data Movimiento = Arriba vertice
  | Abajo vertice
  | Izquierda vertice
  | Derecha vertice
```
dónde cada dirección representa desplazarse en esa dirección 3
unidades del plano euclideo desde el *vertice*.

# Código

## Juego Interactivo

```haskell
pintaMundo :: Mundo -> Picture
```
Se usa para pintar el mundo trás cada interacción del usuario,
solo es necesario usarlo en la definición de la interacción.

```haskell
resuelveEvento :: Event -> Mundo -> Mundo
```
Se usa para manejar cada interacción del usuario, ya sea con el ratón
o con el teclado solo es necesario usarlo en la definición
de la interacción.
Contempla las interacciones

* Click izquierdo para definir el origen de una arista.
* Click central para definir el destino de una arista.
* Tecla *Escape* para reiniciar el juego a su estado inicial.

## Búsqueda de solución en anchura

```haskell
esEstadoFinal :: Estado -> Bool
```
Se usa en cada estado que se alcanza en el arbol de búsqueda para
determinar si se ha llegado a una solución.

```haskell
aplicables :: Estado -> [Movimiento]
```
Se usa para generar las acciones aplicables a cada estado dentro de
la búsqueda BFS.

```haskell
aplica :: Movimiento -> Estado -> Estado
```
Para cada acción aplicable (Cuando generamos el arbol de búsqueda)
esta función se encarga de generar el nuevo estado al que se llega
tras haberla aplicado.

## Ejemplos

Ejecutar resolución en CodeWorld
```haskell
:l Bridges.hs
main
-- Para probar otros niveles cambiar la constante "main_game"
```

Ejecutar y visualizar BFS 
```haskell
:l Bridges_Solver.hs
dibuja_resultado $ busqueda estado1
```

# Referencias

* [Programación declarativa - US](https://www.cs.us.es/cursos/pd/)
* [Wikipedia - BFS](https://en.wikipedia.org/wiki/Breadth-first_search)
* [Aprende Haskell por el bien de todos](http://aprendehaskell.es/main.html)
* [Haskell reference](http://zvon.org/other/haskell/Outputglobal/index.html)
* [CodeWorld reference](https://code.world/doc-haskell/CodeWorld.html)
* [Haskell Text Package](https://hackage.haskell.org/package/text-1.2.3.0/docs/Data-Text.html)
* [Haskell List Package](https://hackage.haskell.org/package/base-4.10.1.0/docs/Data-List.html)
