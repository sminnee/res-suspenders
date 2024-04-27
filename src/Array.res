include Belt.Array

// // Operations on Arrays

let indexOf = Js.Array2.indexOf

let find = Js.Array2.find

let some = Js.Array2.some

let sortInPlaceWith = Js.Array2.sortInPlaceWith

let filter = Js.Array2.filter

let findIndex = Js.Array2.findIndex

// @ocaml.doc("Return the a relative value in an array")
let relValue = (arr, offset, val) =>
  switch getIndexBy(arr, x => x == val) {
  | None => None
  | Some(idx) => get(arr, idx + offset)
  }

@ocaml.doc("Return the previous value in an array")
let prevValue = (arr, val) => relValue(arr, -1, val)

@ocaml.doc("Return the next value in an array")
let nextValue = (arr, val) => relValue(arr, 1, val)
@ocaml.doc("Concat 2 arrays, only adding items from b that don't already appear in a")
let concatUnique = (a, b) =>
  concat(a, Js.Array2.filter(b, bVal => Js.Array2.indexOf(a, bVal) == -1))

@ocaml.doc("Remove None options in an array, containing options")
let removeNone = arr =>
  reduce(arr, [], (accum, valOpt) =>
    switch valOpt {
    | None => accum
    | Some(val) => concat(accum, [val])
    }
  )

@ocaml.doc("Remove Error options in an array containing Results")
let removeError = arr =>
  reduce(arr, [], (accum, resVal) =>
    switch resVal {
    | Result.Error(_) => accum
    | Result.Ok(val) => concat(accum, [val])
    }
  )

@ocaml.doc("Add an item to the end of the array")
let push = (arr, val) => concat(arr, [val])

@ocaml.doc("Immutable array pop")
let pop = arr => {
  let len = length(arr)
  get(arr, len - 1)->Option.mapWithDefault((arr, None), last => (
    slice(arr, ~offset=0, ~len=len - 1),
    Some(last),
  ))
}

@ocaml.doc("Get the last element of an array")
let last = arr => {
  let len = length(arr)
  get(arr, len - 1)
}

@ocaml.doc("Add an item to the start of the array")
let unshift = (arr, val) => concat([val], arr)

@ocaml.doc("Remove an item from an array, if it contains it")
let remove = (arr, val) => keep(arr, x => x != val)

@ocaml.doc("Remove an item from an array by index")
let removeIdx = (arr, idx) => concat(slice(arr, ~offset=0, ~len=idx), sliceToEnd(arr, idx + 1))

@ocaml.doc("Does the array contain the given value")
let has = (arr, val) => getIndexBy(arr, x => x == val)->Option.isSome

@ocaml.doc("Remove many items from an array")
let diff = (arr, vals) => keep(arr, x => !has(vals, x))

@ocaml.doc("Immutable array set")
let withIdx = (arr, idx, val) => mapWithIndex(arr, (curIdx, curVal) => idx == curIdx ? val : curVal)

@ocaml.doc("Map over the given array, dropping any value with none")
let filterMap = (arr, fn) =>
  reduce(arr, [], (accum, val) =>
    switch fn(val) {
    | None => accum
    | Some(result) => push(accum, result)
    }
  )

@ocaml.doc("Turn an array of results into a result of an array. The first error will be returned")
let bubbleError = map =>
  reduce(map, Result.Ok([]), (resAccum, resVal) =>
    switch resAccum {
    | Result.Ok(accum) =>
      switch resVal {
      | Result.Error(x) => Result.Error(x)
      | Result.Ok(val) => Result.Ok(concat(accum, [val]))
      }
    | _ => resAccum
    }
  )

@ocaml.doc("Simple array formatter for signatures")
let toSExpr = arr => reduce(arr, "(", (acc, val) => acc ++ " " ++ val) ++ " )"
