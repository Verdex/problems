
let b =
    fun next ->
    next []

let p = 
    fun stack ->
    fun number ->
    fun next ->
    next (List.cons number stack)

let e = 
    fun stack ->
    List.hd stack

let a = 
    fun stack ->
    fun next ->
    match stack with
    | a::b::r -> next (List.cons (a+b) r)

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
