// Various utility functions, building on the Belt types

include Belt.Option

// Operations on Options

@ocaml("Lazily evaluate the default if the optional returns None.")
let orElse = (optional: option<'a>, default: unit => option<'a>) =>
  switch optional {
  | Some(x) => Some(x)
  | None => default()
  }

@ocaml("Lazily evaluate the default if the optional returns None.")
let withDefault = (optional: option<'a>, default: unit => 'a) =>
  switch optional {
  | Some(x) => x
  | None => default()
  }
