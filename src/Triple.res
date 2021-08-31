// Operations on 3-tuples

@ocaml.doc("Make a triple")
let make = (a, b, c) => (a, b, c)

@ocaml.doc("In a (value, context) pair, update the value")
let setFst = ((a, b, c), updater) => (updater(a), b, c)

@ocaml.doc("In a (value, context) pair, update the context")
let setSnd = ((a, b, c), updater) => (a, updater(b), c)

@ocaml.doc("In a (value, context) pair, update the context")
let setThird = ((a, b, c), updater) => (a, b, updater(c))

@ocaml.doc("Unshift an element on the start of a 3-tuple, producing a 4-tuple")
let unshift = ((a, b, c), extra) => (extra, a, b, c)

@ocaml.doc("Unshift an element on the end of a 3-tuple, producing a 4-tuple")
let push = ((a, b, c), extra) => (a, b, c, extra)
