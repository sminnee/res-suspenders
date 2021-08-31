include Belt.List

@ocaml.doc("Form the cartesian join of two lists, returning a list of every pair, in reverse order")
let cartesian = (a: list<'a>, b: list<'b>): list<('a, 'b)> => {
  reduce(a, list{}, (accum, aVal) => {
    reduce(b, accum, (accum, bVal) => {
      list{(aVal, bVal), ...accum}
    })
  })
}
