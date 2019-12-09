(*Tools*)
open Graph


let clone_nodes gr =  
  n_fold gr (fun ngr id -> new_node  ngr id) empty_graph ;;

let gmap gr f =  e_fold gr (fun g id1 id2 lbl -> new_arc g id1 id2 (f lbl)) (clone_nodes gr)  ;;


let add_arc gr a1 a2 n = 
  if find_arc gr a1 a2 = None
  then new_arc gr a1 a2 n
  else 
    let out = out_arcs gr a1 in
    new_arc gr a1 a2 ((List.assoc a2 out)+n) ;; 
