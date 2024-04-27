@ocaml.doc("Log the execution time of an operation to the console")
let duration = (label, operation: unit => 'a): 'a => {
  let t1 = Js.Date.now()
  let result = operation()
  let t2 = Js.Date.now()
  Js.log4("Execution time", label, (t2 -. t1) /. 1000., "seconds")
  result
}
