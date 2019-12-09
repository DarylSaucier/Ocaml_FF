open Graph




(*we need to define the direction type in order to find the augmenting path *)
type direction = Forward | Backward
type arcspe = int * direction 

(*searching algorithm*) 
val dfs: (int * direction) Graph.graph -> Graph.id -> Graph.id -> Graph.id list

val get_residual_graph: (int * int) Graph.graph -> (int * direction) Graph.graph
(*initialize graphe d'écart*)

(*Updates the residual flow network ; for each edge, the smaller flow is either added to the label or substracted*)
val graph_update: (int * 'a) Graph.graph -> int -> (Graph.id * direction) list -> (int * 'a) Graph.graph

(*final algorithm of ford-fulkerson, returns the flow graph and the maximum flow*)
val ff: int Graph.graph -> Graph.id -> Graph.id -> (int * int) Graph.graph

val string_of_edge: (int * int) -> string


