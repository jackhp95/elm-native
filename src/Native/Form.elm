module Native.Form exposing
    ( form, allForms
    , name, id, target, method, action, enctype, novalidate
    )

import Json.Decode as JD
import Native.Internal exposing (..)



-- Form


form : Data Form a -> Node Form a
form =
    buildNode (\dec -> JD.field "form" dec |> internalDecodeEntry)


allForms : Data Form a -> Node Form (List a)
allForms =
    buildNode internalDecodeAllForms



-- Form Pipes


name : Pipe Form String a
name =
    requiredPipe "name" JD.string


id : Pipe Form String a
id =
    requiredPipe "id" JD.string


target : Pipe Form String a
target =
    requiredPipe "target" JD.string


method : Pipe Form String a
method =
    requiredPipe "method" JD.string


action : Pipe Form String a
action =
    requiredPipe "action" JD.string


enctype : Pipe Form String a
enctype =
    requiredPipe "enctype" JD.string


novalidate : Pipe Form Bool a
novalidate =
    requiredPipe "novalidate" JD.bool
