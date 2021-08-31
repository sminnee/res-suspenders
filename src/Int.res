include Belt.Int

@ocaml.doc("Return the integer into a string such as '+1', '+0' or '-1'")
let signedString = val => (val < 0 ? "" : "+") ++ toString(val)
