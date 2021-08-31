include Belt.Set

let map = (set, mapper, ~id) => toArray(set)->Array.map(mapper)->fromArray(~id)
