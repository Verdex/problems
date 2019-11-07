
type instr = 
    | Push of int
    | Add

let b = 
    fun next -> 
    next []

let p =
    fun inst ->
    fun num -> 
    fun next ->
    next (List.cons (Push num) inst)

let e =
    fun inst ->
    let stack = List.fold_left
        (fun s i -> match i with
                    | Push n -> List.cons n s
                    | Add -> (match s with
                              | a::b::r -> List.cons (a+b) r))
        []
        (List.rev inst)
    in List.hd stack

let a =
    fun inst ->
    fun next ->
    next (List.cons Add inst)

let p1 = b p 0 e

let p2 = b p 1 p 2 a e

let p3 = b p 1 p 2 a p 3 a e

let print (i:int) = Printf.printf "%d\n" i

;;

print p1

;;

print p2

;;

print p3


