module Native.Form exposing (..)

import Json.Decode as JD
import Json.Decode.Pipeline as JP
import Native.Internal exposing (..)



-- Form


form : Data Form a -> Node Form a
form (Data dec) =
    JD.field "form" dec
        |> internalDecodeEntry
        |> Node


allForms : Data Form a -> Node Form (List a)
allForms (Data dec) =
    internalDecodeAllForms dec
        |> Node



-- Form Pipes


name : Pipe Form String a
name (Data dec) =
    dec
        |> JP.required "name" JD.string
        |> Data


id : Pipe Form String a
id (Data dec) =
    dec
        |> JP.required "id" JD.string
        |> Data


target : Pipe Form String a
target (Data dec) =
    dec
        |> JP.required "target" JD.string
        |> Data


method : Pipe Form String a
method (Data dec) =
    dec
        |> JP.required "method" JD.string
        |> Data


action : Pipe Form String a
action (Data dec) =
    dec
        |> JP.required "action" JD.string
        |> Data


enctype : Pipe Form String a
enctype (Data dec) =
    dec
        |> JP.required "enctype" JD.string
        |> Data


novalidate : Pipe Form Bool a
novalidate (Data dec) =
    dec
        |> JP.required "novalidate" JD.bool
        |> Data
