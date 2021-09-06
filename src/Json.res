module Read = {
  include Js.Json

  exception ParseException(string)

  @ocaml.doc("Raise a parse exception on a non-array; classify all elements")
  let taggedArrayTagged = json =>
    switch json {
    | JSONArray(arr) => Array.map(arr, classify)
    | _ => raise(ParseException("Expected array"))
    }

  @ocaml.doc("Raise a parse exception on a non-array; classify all elements")
  let taggedArray = json => classify(json)->taggedArrayTagged

  @ocaml.doc("Extract the given key from a Json dict, as an option")
  let optKey = (dict: Js.Dict.t<t>, key, mapper) =>
    Js.Dict.get(dict, key)->Option.map(classify)->Option.map(mapper)

  @ocaml.doc("Extract the given key from a Json dict, or raise an error")
  let key = (dict: Js.Dict.t<t>, key, mapper) =>
    switch optKey(dict, key, mapper) {
    | Some(value) => value
    | _ => raise(ParseException("\"" ++ "key" ++ "\" must be a string"))
    }

  let string = taggedJson =>
    switch taggedJson {
    | JSONString(string) => string
    | _ => raise(ParseException("String expected"))
    }

  let int = taggedJson =>
    switch taggedJson {
    | JSONNumber(num) => Int.fromFloat(num)
    | _ => raise(ParseException("Number expected"))
    }

  let float = taggedJson =>
    switch taggedJson {
    | JSONNumber(num) => num
    | _ => raise(ParseException("Number expected"))
    }

  let bool = taggedJson =>
    switch taggedJson {
    | JSONTrue => true
    | JSONFalse => false
    | _ => raise(ParseException("Boolean expected"))
    }

  let pair = (taggedJson, mapper) =>
    switch taggedJson {
    | JSONArray([item1, item2]) => (mapper(classify(item1)), mapper(classify(item2)))
    | _ => raise(ParseException("expected an array"))
    }

  let array = (taggedJson, mapper) =>
    switch taggedJson {
    | JSONArray(arr) => Array.map(arr, json => json->classify->mapper)
    | _ => raise(ParseException("expected an array"))
    }

  let map = (taggedJson, mapper) =>
    switch taggedJson {
    | JSONObject(dict) =>
      Js.Dict.map((. json) => json->classify->mapper, dict)->Js.Dict.entries->StrMap.fromArray
    | _ => raise(ParseException("expected a JSON object"))
    }

  let dict = taggedJson =>
    switch taggedJson {
    | JSONObject(dict) => dict
    | _ => raise(ParseException("Items must be JSON objects"))
    }
}

// Builders

module Write = {
  @ocaml.doc("A key/value property for building a JSON dict that may be missing")
  type prop = option<(string, Js.Json.t)>

  @ocaml.doc("Helper for adding optional properties to built JSON dict")
  let optProp = (value, key, mapper): prop => {
    Option.map(value, x => (key, mapper(x)))
  }

  @ocaml.doc("Helper for adding properties to built JSON dict")
  let prop = (value, key, mapper): prop => {
    Some(key, mapper(value))
  }

  let array = Js.Json.array
  let number = Js.Json.number
  let string = Js.Json.string
  let stringArray = Js.Json.stringArray
  let object_ = Js.Json.object_
  let boolean = Js.Json.boolean

  let stringify = Js.Json.stringify

  let mappedArray = (mapper, arr) => arr->Array.map(mapper)->array

  @ocaml.doc("Write a set as a JSON array with the given mapper")
  let set = (mapper, set) => set->Set.toArray->Array.map(mapper)->array

  let int = x => x->Int.toFloat->Js.Json.number

  let pair = (mapper, (a, b)) => Js.Json.array([mapper(a), mapper(b)])

  @ocaml.doc("Write an array of pairs to a JSON object with the given mapper")
  let dict = arr => arr->Js.Dict.fromArray->object_

  @ocaml.doc("Write an array of props to a JSON object, exlcuding the missing ones")
  let propDict = (arr: array<prop>) => arr->Array.removeNone->dict

  @ocaml.doc("Write a StrMap to a JSON object with the given mapper")
  let strMap = map => map->StrMap.toArray->dict

  @ocaml.doc("Write an optional string to JSON with the given default value")
  let optString = (val, default) => Option.getWithDefault(val, default)->string
}
