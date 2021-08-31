// Operations on 2-tuples

@ocaml.doc("Create a pair")
let make = (a, b) => (a, b)

@ocaml.doc("In a (value, context) pair, update the value")
let setFst = ((a, b), updater) => (updater(a), b)

@ocaml.doc("In a (value, context) pair, update the context")
let setSnd = ((a, b), updater) => (a, updater(b))

@ocaml.doc("In an option<(a,b)> pair, update a")
let setOptFst = (optPair, default, updater) =>
  switch optPair {
  | None => Some(updater(None), default)
  | Some((a, b)) => Some(updater(Some(a)), b)
  }

@ocaml.doc("In an option<(a,b)> pair, update b")
let setOptSnd = (optPair, default, updater) =>
  switch optPair {
  | None => Some(default, updater(None))
  | Some((a, b)) => Some(a, updater(Some(b)))
  }

@ocaml.doc("Unshift an element on the start of a 2-tuple, producing a 3-tuple")
let unshift = ((a, b), extra) => (extra, a, b)

@ocaml.doc("Unshift an element on the end of a 2-tuple, producing a 3-tuple")
let push = ((a, b), extra) => (a, b, extra)
