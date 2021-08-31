include Belt.Result

let combineErrors = (a, b) =>
  Belt.Array.concat(a, Js.Array2.filter(b, bVal => Js.Array2.indexOf(a, bVal) == -1))


@ocaml.doc("Combine 2 results into a tuple or pass back the existing error lists.")
let combine2 = (a, b) =>
  switch (a, b) {
  | (Ok(val1), Ok(val2)) => Ok((val1, val2))
  | (Error(message), Ok(_)) => Error(message)
  | (Ok(_), Error(message)) => Error(message)
  | (Error(message1), Error(message2)) =>
    Error(combineErrors(message1, message2))
  }

@ocaml.doc("Combine 3 results into a tuple or pass back the existing error lists.")
let combine3 = (a, b, c) => {
  let errors = result =>
    switch result {
    | Error(x) => x
    | Ok(_) => []
    }
  switch (a, b, c) {
  | (Ok(val1), Ok(val2), Ok(val3)) => Ok((val1, val2, val3))
  | _ => Error(combineErrors(combineErrors(errors(a), errors(b)), errors(c)))
  }
}

let ok = x => Ok(x)

@ocaml.doc("Convert an option to a result, using the given error message for None")
let fromOption = (optX, err) =>
  switch optX {
  | Some(x) => Ok(x)
  | None => Error(err)
  }


@ocaml("Convert a result to an option")
let toOption = res =>
  switch res {
  | Ok(x) => Some(x)
  | Error(_) => None
  }


@ocaml.doc("Map individual error messages")
let mapMessage = (result, updater) =>
  switch result {
  | Ok(_) => result
  | Error(messages) => Error(Belt.Array.map(messages, updater))
  }
