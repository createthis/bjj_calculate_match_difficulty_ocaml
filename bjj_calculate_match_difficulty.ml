open Yojson.Basic.Util

let belt_rankings = ["white"; "blue"; "purple"; "brown"; "black"]

let belt_to_rank belt =
  match List.find_index ((=) belt) belt_rankings with
  | Some index -> index
  | None -> failwith "Belt not found"

let age_to_belt_rank age =
  (float_of_int age) /. 10.0

let weight_to_belt_rank weight =
  (float_of_int weight) /. 20.0

let height_to_belt_rank height =
  (float_of_int height) /. 6.0

type practitioner = {
  belt : string;
  age : int;
  weightInPounds : int;
  heightInInches : int;
}

let json_to_practitioner json = {
  belt = json |> member "belt" |> to_string;
  age = json |> member "age" |> to_int;
  weightInPounds = json |> member "weightInPounds" |> to_int;
  heightInInches = json |> member "heightInInches" |> to_int;
}

let bjj_calculate_match_difficulty p1_json p2_json =
  let p1 = json_to_practitioner p1_json in
  let p2 = json_to_practitioner p2_json in
  let p1_belt = p1.belt |> String.lowercase_ascii |> belt_to_rank in
  let p2_belt = p2.belt |> String.lowercase_ascii |> belt_to_rank in
  let age_diff = age_to_belt_rank (p1.age - p2.age) in
  let weight_diff = weight_to_belt_rank (p2.weightInPounds - p1.weightInPounds) in
  let height_diff = height_to_belt_rank (p2.heightInInches - p1.heightInInches) in
  let belt_diff = float_of_int(p2_belt - p1_belt) in
  (belt_diff +. age_diff +. weight_diff +. height_diff) *. -1.0

let () =
  let p1_json = Yojson.Basic.from_string {|{ 
    "belt": "white",
    "age": 42,
    "weightInPounds": 175,
    "heightInInches": 69
  }|} in
  let p2_json = Yojson.Basic.from_string {|{ 
    "belt": "blue",
    "age": 25,
    "weightInPounds": 160,
    "heightInInches": 65
  }|} in
  let result = bjj_calculate_match_difficulty p1_json p2_json in
  print_float result
