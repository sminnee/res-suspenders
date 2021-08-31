include Belt.Set.String

@ocaml.doc("Return a list of all subsets of the given set, including empty and itself")
let powerSet = set =>
  reduce(set, [empty], (accum, item) => {
    Array.concat(Array.map(accum, add(_, item)), accum)
  })
