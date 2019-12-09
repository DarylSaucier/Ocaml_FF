open Graph 
open Tools

(*
+++++++   WE DEFINE HERE :
+++++++ 
+++++++       - the direction type, to know wether we are going in the way of the the dfs algorithm or the other one
+++++++       - the arcspe type, which is an arc with its label and a direction
+++++++       - the residual_graph, which is an arcspe Graph.graph
+++++++       - the edges, which are composed of a flow (actualizing in the final algorithm) and a capacity (which is given with the first graph)
+++++++       - the reseau type is an edge Graph.graph 
+++++++       - the Augmenting_Path excpetion will be raised in our DFS algorithm, when a correct path is found
*)


type direction = Forward | Backward
type arcspe = int * direction
type residual_graph = arcspe graph
type flow = int
type capacity = int
type edge = flow * capacity
type reseau = edge graph
exception Augmenting_Path of (((id * direction) list) * int)



(* This function allows us to export the final graph, by keeping only the flow of the graph *)
let string_of_edge (flow, capacity) = string_of_int flow

(* transforming int graphs into (int * 'a) graphs *)
let transfo a = (0, a);;

(* Initializing a new graph *)
let init_gr gr = gmap gr transfo ;;

(* Initializing a residual graph from an (int * int) Graph to a (int * direction) graph *)
let get_residual_graph gr = 
  let cloned = clone_nodes gr in
  e_fold
    gr
    (fun residual_graph id1 id2 (flow, capacity) ->
       if capacity <> 0 then
         (*We update the residual graph only if the capacity is not 0*)
         begin
           if flow <> 0 && flow <> capacity then
             (*We put the new value into the edge, in the Forward direction *)
             let new_residual_graph = new_arc residual_graph id1 id2 (capacity - flow, Forward) in
             new_arc new_residual_graph id2 id1 (flow, Backward) 
           else if flow = 0 then
             (*If the flow = 0, then we put the full capacity in the residual edge between id1 and id2 (Forward)*)
             new_arc residual_graph id1 id2 (capacity, Forward)
           else
             (*If the flow = capacity, then we put it in the residual edge, but between id2 and id2 (Backward) *)
             new_arc residual_graph id2 id1 (capacity, Backward)
         end
       else
         residual_graph)
    cloned



(* Depth First Search algorithm *)
let dfs rg sc sk = 
  let rec _dfs acc ppl visited = function
    | []            -> visited
    | (id, (lbl, direction))::t  -> 
      (*We stop the loop if the node corresponds to the one we were looking for*)
      if id = sk then
        let delta = if lbl < ppl || ppl = 0 then lbl else ppl in
        raise (Augmenting_Path (List.rev ((sk, direction)::acc), delta))

      else if List.mem id visited then
        (*the node is already visited, we simply go to parse the next one*)
        _dfs acc ppl visited t

      else
        (*We visit here a new node and put it into the visited list*)
        let new_visited =
          if lbl < ppl || ppl = 0 then
            _dfs ((id, direction)::acc) lbl (id::visited) (out_arcs rg id)
          else
            _dfs ((id, direction)::acc) ppl (id::visited) (out_arcs rg id)
        in
        _dfs acc ppl new_visited t
  in    _dfs [(sc, Forward)] 0 [sc] (out_arcs rg sc)





(*This function updates an edge by adding the smaller label (ppl) to the actual lbl*)
let update_edge fn id1 id2 ppl =
  match find_arc fn id1 id2 with 
  | None  -> fn
  | Some (flow, capacity) -> new_arc fn id1 id2 (flow + ppl, capacity)

(* Updating a graph with a list of nodes and the smaller label of a path*)
let rec graph_update graph ppl = function 
  | [] -> graph 
  | [(id, direction)] -> graph
  (*We must keep the entire ((id, direction)::t) so we call 'as tail' to call recursively the function with the entire block*)
  | (id1, direction1)::((id2, direction2)::t as tail) ->
    match direction2 with 
    (*If the direction is Forward, then we add the ppl (smaller label) to the edge*)
    | Forward -> graph_update  (update_edge graph id1 id2 ppl) ppl tail
    (*If the direction is Backward, then we substract the ppl (smaller label) to the edge*)
    | Backward -> graph_update  (update_edge graph id1 id2 (-ppl)) ppl tail
;;



(* The final Ford Fulkerson algorithm *)
let ff graph sc sk =
  let gr = init_gr graph in
  let rec ffrec gr = 
    let ecart = get_residual_graph gr in
    try 
      let _ = dfs ecart sc sk in
      gr

    with (Augmenting_Path (path, ppl)) -> ffrec (graph_update gr ppl path)   
  in  
  ffrec gr
;;