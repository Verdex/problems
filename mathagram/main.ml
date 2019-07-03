let (|>) a b = b a
;;

let rec skip l i = 
    match l with
    | [] -> []
    | h::t -> (match i with 
               | 0 -> h::t
               | _ -> skip t (i-1))
;;

let one_lhs = [ `Hun(Some(1), 1) ; `Ten(None, 1) ; `One(None, 1) 
              ; `Hun(None, 2) ; `Ten(None, 2) ; `One(None, 2)
              ]
;;

let one_rhs = [ `Hun(Some(4), 1) ; `Ten(Some(6), 1) ; `One(Some(8), 1) ]
;;

let display l =
    let terms = List.map (function `Hun(_, x) -> x | `Ten(_, x) -> x | `One(_, x) -> x) l
              |> distinct
    in
    terms
;; 

let rec remove_first n l = 
    match l with
    | [] -> []
    | (h::t) when h = n -> t 
    | (h::t) -> h :: (remove_first n t)

;;

let solve eq numbers =  
         

