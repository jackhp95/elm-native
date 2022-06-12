module Native.Internal exposing (..)

import Array exposing (Array)
import Dict exposing (Dict)
import Json.Decode as JD exposing (Value)
import Json.Decode.Extra as JD
import Json.Decode.Pipeline as JP
import Set exposing (Set)
import Time exposing (Posix)
import Url exposing (Url)


type Entry
    = Entry


type Form
    = Form


type Window
    = Window



-- There's an issue of confusing nodes, and data.
-- Element, Form, Window, should all be treated differently than
-- data like: name, value, method, enctype, id
-- How do I denote the distinction in types to prevent abuse?


type Node native a
    = Node (JD.Decoder a)


type Data native a
    = Data (JD.Decoder a)


type alias Pipe native a b =
    Data native (a -> b) -> Data native b

type Persist = Persist JD.Value

-- ---------- --
-- Structures --
-- ---------- --
-- Form type and Entry type provide Typesafe ways of composing and navigating the DOM
-- It's important to get it correct so we can rely on these types to assist in composition


internalDecodeEntry : JD.Decoder a -> JD.Decoder a
internalDecodeEntry dec =
    JD.oneOf [ JD.field "submitter" dec, JD.field "target" dec ]


internalDecodeAllForms : JD.Decoder a -> JD.Decoder (List a)
internalDecodeAllForms dec =
    JD.keyValuePairs dec
        |> JD.map (List.map Tuple.second)
        |> JD.at [ "ownerDocument", "forms" ]
        |> internalDecodeEntry



-- Decoder API


string : Data native String
string =
    Data JD.string


bool : Data native Bool
bool =
    Data JD.bool


int : Data native Int
int =
    Data JD.int


float : Data native Float
float =
    Data JD.float


nullable : Data native a -> Data native (Maybe a)
nullable (Data a) =
    Data (JD.nullable a)


list : Data native a -> Data native (List a)
list (Data a) =
    Data (JD.list a)


array : Data native a -> Data native (Array a)
array (Data a) =
    Data (JD.array a)


dict : Data native a -> Data native (Dict String a)
dict (Data a) =
    Data (JD.dict a)


keyValuePairs : Data native a -> Data native (List ( String, a ))
keyValuePairs (Data a) =
    Data (JD.keyValuePairs a)


oneOrMore : (a -> List a -> value) -> Data native a -> Data native value
oneOrMore fn (Data a) =
    Data (JD.oneOrMore fn a)


field : String -> Data native a -> Data native a
field str (Data a) =
    Data (JD.field str a)


at : List String -> Data native a -> Data native a
at strs (Data a) =
    Data (JD.at strs a)


index : Int -> Data native a -> Data native a
index index_ (Data a) =
    Data (JD.index index_ a)


maybe : Data native a -> Data native (Maybe a)
maybe (Data a) =
    Data (JD.maybe a)


oneOf : List (Data native a) -> Data native a
oneOf list_ =
    list_
        |> List.map (\(Data a) -> a)
        |> JD.oneOf
        |> Data


map : (a -> value) -> Data native a -> Data native value
map fn (Data dec1) =
    Data (JD.map fn dec1)


map2 : (a -> b -> value) -> Data native a -> Data native b -> Data native value
map2 fn (Data dec1) (Data dec2) =
    Data (JD.map2 fn dec1 dec2)


map3 : (a -> b -> c -> value) -> Data native a -> Data native b -> Data native c -> Data native value
map3 fn (Data dec1) (Data dec2) (Data dec3) =
    Data (JD.map3 fn dec1 dec2 dec3)


map4 : (a -> b -> c -> d -> value) -> Data native a -> Data native b -> Data native c -> Data native d -> Data native value
map4 fn (Data dec1) (Data dec2) (Data dec3) (Data dec4) =
    Data (JD.map4 fn dec1 dec2 dec3 dec4)


map5 : (a -> b -> c -> d -> e -> value) -> Data native a -> Data native b -> Data native c -> Data native d -> Data native e -> Data native value
map5 fn (Data dec1) (Data dec2) (Data dec3) (Data dec4) (Data dec5) =
    Data (JD.map5 fn dec1 dec2 dec3 dec4 dec5)


map6 : (a -> b -> c -> d -> e -> f -> value) -> Data native a -> Data native b -> Data native c -> Data native d -> Data native e -> Data native f -> Data native value
map6 fn (Data dec1) (Data dec2) (Data dec3) (Data dec4) (Data dec5) (Data dec6) =
    Data (JD.map6 fn dec1 dec2 dec3 dec4 dec5 dec6)


map7 : (a -> b -> c -> d -> e -> f -> g -> value) -> Data native a -> Data native b -> Data native c -> Data native d -> Data native e -> Data native f -> Data native g -> Data native value
map7 fn (Data dec1) (Data dec2) (Data dec3) (Data dec4) (Data dec5) (Data dec6) (Data dec7) =
    Data (JD.map7 fn dec1 dec2 dec3 dec4 dec5 dec6 dec7)


map8 : (a -> b -> c -> d -> e -> f -> g -> h -> value) -> Data native a -> Data native b -> Data native c -> Data native d -> Data native e -> Data native f -> Data native g -> Data native h -> Data native value
map8 fn (Data dec1) (Data dec2) (Data dec3) (Data dec4) (Data dec5) (Data dec6) (Data dec7) (Data dec8) =
    Data (JD.map8 fn dec1 dec2 dec3 dec4 dec5 dec6 dec7 dec8)


succeed : a -> Data native a
succeed =
    Data << JD.succeed


andThen : (a -> Data native b) -> Data native a -> Data native b
andThen fn (Data a) =
    JD.map fn a
        |> JD.andThen (\(Data b) -> b)
        |> Data


lazy : (() -> Data native a) -> Data native a
lazy fn =
    JD.lazy (fn >> (\(Data a) -> a))
        |> Data



-- We specify Window here to Prevent Form/Entries to preserve references after the event


value : Data Window Persist
value =
    Data (JD.map Persist JD.value)
        


null : a -> Data native a
null =
    Data << JD.null



-- Pipeline API


required : String -> Data native a -> Data native (a -> b) -> Data native b
required str (Data a) (Data ab) =
    Data (JP.required str a ab)


requiredAt : List String -> Data native a -> Data native (a -> b) -> Data native b
requiredAt str (Data a) (Data ab) =
    Data (JP.requiredAt str a ab)


optional : String -> Data native a -> a -> Data native (a -> b) -> Data native b
optional str (Data a) fallback (Data ab) =
    Data (JP.optional str a fallback ab)


optionalAt : List String -> Data native a -> a -> Data native (a -> b) -> Data native b
optionalAt str (Data a) fallback (Data ab) =
    Data (JP.optionalAt str a fallback ab)


hardcoded : a -> Data native (a -> b) -> Data native b
hardcoded a (Data ab) =
    Data (JP.hardcoded a ab)


custom : Data native a -> Data native (a -> b) -> Data native b
custom (Data a) (Data ab) =
    Data (JP.custom a ab)


resolve : Data native (Data native a) -> Data native a
resolve (Data a) =
    JD.andThen (\(Data b) -> b) a
        |> Data



-- Extra API


datetime : Data native Posix
datetime =
    Data JD.datetime


url : Data native Url
url =
    Data JD.url


andMap : Data native a -> Data native (a -> b) -> Data native b
andMap (Data a) (Data ab) =
    JD.andMap a ab
        |> Data


when : Data native a -> (a -> Bool) -> Data native b -> Data native b
when (Data a) fn (Data b) =
    JD.when a fn b
        |> Data


collection : Data native a -> Data native (List a)
collection (Data a) =
    JD.collection a
        |> Data


sequence : List (Data native a) -> Data native (List a)
sequence list_ =
    list_
        |> List.map (\(Data a) -> a)
        |> JD.sequence
        |> Data


combine : List (Data native a) -> Data native (List a)
combine list_ =
    list_
        |> List.map (\(Data a) -> a)
        |> JD.combine
        |> Data


indexedList : (Int -> Data native a) -> Data native (List a)
indexedList fn =
    JD.indexedList (fn >> (\(Data a) -> a))
        |> Data


keys : Data native (List String)
keys =
    Data JD.keys


set : Data native comparable -> Data native (Set comparable)
set (Data a) =
    JD.set a
        |> Data


dict2 : Data native comparable -> Data native v -> Data native (Dict comparable v)
dict2 (Data a) (Data v) =
    JD.dict2 a v
        |> Data


withDefault : a -> Data native a -> Data native a
withDefault default_ (Data a) =
    JD.withDefault default_ a
        |> Data


optionalField : String -> Data native a -> Data native (Maybe a)
optionalField str (Data a) =
    JD.optionalField str a
        |> Data


optionalNullableField : String -> Data native a -> Data native (Maybe a)
optionalNullableField str (Data a) =
    JD.optionalNullableField str a
        |> Data


fromMaybe : String -> Maybe a -> Data native a
fromMaybe str a =
    JD.fromMaybe str a
        |> Data


fromResult : Result String a -> Data native a
fromResult a =
    JD.fromResult a
        |> Data


parseInt : Data native Int
parseInt =
    Data JD.parseInt


parseFloat : Data native Float
parseFloat =
    Data JD.parseFloat


doubleEncoded : Data native a -> Data native a
doubleEncoded (Data a) =
    JD.doubleEncoded a
        |> Data
