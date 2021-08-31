// Map with string keys

include Belt.Map.String

@ocaml.doc("Remove None options in a map containing options")
let removeNone = map =>
  reduce(map, empty, (accum, key, valOpt) =>
    switch valOpt {
    | None => accum
    | Some(val) => set(accum, key, val)
    }
  )

@ocaml.doc("Remove Error options in a map containing Results")
let removeError = map => {
  reduce(map, empty, (accum, key, resVal) =>
    switch resVal {
    | Result.Error(_) => accum
    | Result.Ok(val) => set(accum, key, val)
    }
  )
}

@ocaml.doc("Turn a map of results into a result of a map. The first error will be returned")
let bubbleError = map => {
  reduce(map, Ok(empty), (resAccum, key, resVal) =>
    switch resAccum {
    | Result.Ok(accum) =>
      switch resVal {
      | Result.Error(x) => Result.Error(x)
      | Result.Ok(val) => Result.Ok(set(accum, key, val))
      }
    | _ => resAccum
    }
  )
}


@ocaml.doc("Generate a Map.String from an array, using a mapping function to generate keys")
let fromArrayDerivingKeys = (arr, keyFn) => Array.map(arr, val => (keyFn(val), val))->fromArray

@ocaml.doc(
  "Combine 2 maps with matching keys into a map of tuples. The intersection of keys is used"
)
let combine_intersect = (mapA, mapB) =>
  reduce(mapA, empty, (accum, k, vA) =>
    switch get(mapB, k) {
    | Some(vB) => set(accum, k, (vA, vB))
    | None => accum
    }
  )

@ocaml.doc(
  "Combine 2 maps with matching keys into a map of tuples. Keys of first map are used; 2nd element is an option"
)
let combine = (mapA, mapB) =>
  reduce(mapA, empty, (accum, k, vA) =>
    set(accum, k, (vA, get(mapB, k)))
  )
