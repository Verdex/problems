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
    let p a = 
        match a with
        | `Hun(Some(x),_) -> Printf.sprintf "%d" x
        | `Hun(None,_) -> "x"
        | `Ten(Some(x),_) -> Printf.sprintf "%d" x
        | `Ten(None,_) -> "x"
        | `One(Some(x),_) -> Printf.sprintf "%d" x
        | `One(None,_) -> "x"
    in
    let c a b = 
        if a < b then 
            -1
        else if a > b then
            1
        else
            0
    in
    let terms = List.map (function `Hun(_, x) -> x | `Ten(_, x) -> x | `One(_, x) -> x) l
              |> List.sort_uniq  c
    in
    List.iter (fun t -> 
        let items = List.filter (function `Hun(_,x) -> x = t | `Ten(_,x) -> x = t | `One(_,x) -> x = t) l in
        let hun = List.find (function `Hun(_,_) -> true | _ -> false) items in
        let ten = List.find (function `Ten(_,_) -> true | _ -> false) items in
        let one = List.find (function `One(_,_) -> true | _ -> false) items in
        Printf.printf "%s%s%s " (p hun) (p ten) (p one)
    ) terms
;; 

let rec remove_first n l = 
    match l with
    | [] -> []
    | (h::t) when h = n -> t 
    | (h::t) -> h :: (remove_first n t)

;;

display [`Hun(Some(1), 1) ; `One(None, 2) ; `Ten(None, 1) ; `One(Some(5), 1) ; `Ten(None, 2) ; `Hun(None, 2)]

(*let solve eq numbers =  
    let consts = List.filter (function `Hun(Some(_),_)         *)

