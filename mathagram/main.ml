type term = { hun : int option
            ; ten : int option
            ; one : int option
            }
;;

type eq = { lhs : term list
          ; rhs : term list
          }
;;

let display eq = 
    let c_display = function Some i -> Printf.sprintf "%d" i | None -> "x" in
    let term_display t =
        Printf.sprintf "%s%s%s" (c_display t.hun) (c_display t.ten) (c_display t.one)
    in
    List.iter (fun v -> Printf.printf "%s " (term_display v)) eq.lhs
    ;
    Printf.printf "= "
    ;
    List.iter (fun v -> Printf.printf "%s " (term_display v)) eq.rhs
    ;
    Printf.printf "\n"
;;

let one = { lhs = [ { hun = Some(1); ten = None; one = None } ; 
                    { hun = None; ten = None; one = None } ]
          ; rhs = [ { hun = Some(4); ten = Some(6); one = Some(8) } ] 
          }

;;

let rec skip l i = 
    match l with
    | [] -> []
    | h::t -> (match i with 
               | 0 -> h::t
               | _ -> skip t (i-1))
;;

let (|>) a b = b a
;;

display one
