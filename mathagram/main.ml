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

let d i = 
    match i with
    | `Hun(Some(i), t) -> Printf.sprintf "Hun(%d, %d)" i t
    | `Hun(None, t) -> Printf.sprintf "Hun(x, %d)" t
    | `Ten(Some(i), t) -> Printf.sprintf "Ten(%d, %d)" i t
    | `Ten(None, t) -> Printf.sprintf "Ten(x, %d)" t
    | `One(Some(i), t) -> Printf.sprintf "One(%d, %d)" i t
    | `One(None, t) -> Printf.sprintf "One(x, %d)" t
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

let rec remove_first e n l = 
    match l with
    | [] -> []
    | (h::t) when e h n -> t 
    | (h::t) -> h :: (remove_first e n t)

;;

let solve lhs rhs (numbers : int list) =  
    let p i =
        match i with
        | `Hun(Some(v),_) -> v
        | `Ten(Some(v),_) -> v
        | `One(Some(v),_) -> v
    in
    let determine_one l = 
        List.filter (function `One(_,_) -> true | _ -> false) l
        |> List.map p
        |> List.fold_left (+) 0  (* need remainer ... also not sure how to handle determine ten, hun*)
    in
    let get_consts x = List.filter (function `Hun(Some(_),_) -> true 
                                           | `Ten(Some(_),_) -> true 
                                           | `One(Some(_),_) -> true 
                                           | _ -> false) x 
    in
    let filter_numbers consts ns = List.filter (fun n -> List.for_all (fun t -> n <> t) consts) ns in

    let r_consts = get_consts rhs in 
    let l_consts = get_consts lhs in 
    let avail_numbers = filter_numbers (List.map p l_consts) numbers
                     |> filter_numbers (List.map p r_consts)
    in
             

    List.iter (fun x -> Printf.printf "%d\n" x) avail_numbers 
    ; 
    Printf.printf "%d\n" (determine_one [`One(Some(1),6)])

;;

solve one_lhs one_rhs [1;2;3;4;5;6;7;8;9]

