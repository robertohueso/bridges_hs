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


# Código
## Ejemplos
# Referencias
