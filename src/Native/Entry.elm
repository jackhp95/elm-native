module Native.Entry exposing (..)

import Json.Decode as JD
import Json.Decode.Extra as JD
import Json.Decode.Pipeline as JP
import Native.Internal exposing (..)



-- Entry


entry : Data Entry a -> Node Entry a
entry (Data dec) =
    internalDecodeEntry dec
        |> Node


formEntries : Data Entry a -> Node Entry (List a)
formEntries (Data dec) =
    JD.collection (JD.oneOf [ JD.map Just dec, JD.succeed Nothing ])
        |> JD.map (List.filterMap identity)
        |> JD.at [ "form", "elements" ]
        |> internalDecodeEntry
        |> Node


allFormEntries : Data Entry a -> Node Entry (List a)
allFormEntries (Data dec) =
    JD.collection (JD.oneOf [ JD.map Just dec, JD.succeed Nothing ])
        |> JD.map (List.filterMap identity)
        |> JD.at [ "elements" ]
        |> internalDecodeAllForms
        |> JD.map List.concat
        |> Node



-- Entry Pipes


nonEmptyString : JD.Decoder String
nonEmptyString =
    JD.andThen
        (\str ->
            if String.isEmpty str then
                JD.fail "empty name field"

            else
                JD.succeed str
        )
        JD.string


isActiveElement : Pipe Entry Bool a
isActiveElement (Data dec) =
    dec
        |> JP.custom
            (JD.oneOf
                [ JD.map2 (==)
                    (JD.at [ "ownerDocument", "activeElement", "name" ] nonEmptyString)
                    (JD.field "name" nonEmptyString)
                , JD.succeed False
                ]
            )
        |> Data


id : Pipe Entry String a
id (Data dec) =
    dec
        |> JP.required "id" JD.string
        |> Data


textContent : Pipe Entry String a
textContent (Data dec) =
    dec
        |> JP.required "textContent" JD.string
        |> Data


type_ : Pipe Entry String a
type_ (Data dec) =
    dec
        |> JP.required "type" JD.string
        |> Data


tagName : Pipe Entry String a
tagName (Data dec) =
    dec
        |> JP.required "tagName" JD.string
        |> Data


name : Pipe Entry String a
name (Data dec) =
    dec
        |> JP.required "name" JD.string
        |> Data


formAction : Pipe Entry String a
formAction (Data dec) =
    dec
        |> JP.required "formAction" JD.string
        |> Data


formEnctype : Pipe Entry String a
formEnctype (Data dec) =
    dec
        |> JP.required "formEnctype" JD.string
        |> Data


formMethod : Pipe Entry String a
formMethod (Data dec) =
    dec
        |> JP.required "formMethod" JD.string
        |> Data


formNoValidate : Pipe Entry Bool a
formNoValidate (Data dec) =
    dec
        |> JP.required "formNoValidate" JD.bool
        |> Data


isConnected : Pipe Entry Bool a
isConnected (Data dec) =
    dec
        |> JP.required "isConnected" JD.bool
        |> Data


files : Pipe Entry JD.Value a
files (Data dec) =
    dec
        |> JP.required "files" JD.value
        |> Data


value : Pipe Entry String a
value (Data dec) =
    dec
        |> JP.required "value" JD.string
        |> Data


valueAsDate : Pipe Entry String a
valueAsDate (Data dec) =
    dec
        |> JP.required "valueAsDate" JD.string
        |> Data


valueAsInt : Pipe Entry Int a
valueAsInt (Data dec) =
    dec
        |> JP.required "valueAsNumber" JD.int
        |> Data


valueAsFloat : Pipe Entry Float a
valueAsFloat (Data dec) =
    dec
        |> JP.required "valueAsNumber" JD.float
        |> Data


defaultValue : Pipe Entry String a
defaultValue (Data dec) =
    dec
        |> JP.required "defaultValue" JD.string
        |> Data


checked : Pipe Entry (Maybe Bool) a
checked (Data dec) =
    dec
        |> JP.optional "checked" (JD.map Just JD.bool) Nothing
        |> Data


defaultChecked : Pipe Entry (Maybe Bool) a
defaultChecked (Data dec) =
    dec
        |> JP.optional "defaultChecked" (JD.map Just JD.bool) Nothing
        |> Data


multiple : Pipe Entry (Maybe Bool) a
multiple (Data dec) =
    dec
        |> JP.optional "multiple" (JD.map Just JD.bool) Nothing
        |> Data


required : Pipe Entry Bool a
required (Data dec) =
    dec
        |> JP.required "required" JD.bool
        |> Data


readOnly : Pipe Entry Bool a
readOnly (Data dec) =
    dec
        |> JP.required "readOnly" JD.bool
        |> Data


hidden : Pipe Entry Bool a
hidden (Data dec) =
    dec
        |> JP.required "hidden" JD.bool
        |> Data


disabled : Pipe Entry Bool a
disabled (Data dec) =
    dec
        |> JP.required "disabled" JD.bool
        |> Data


willValidate : Pipe Entry Bool a
willValidate (Data dec) =
    dec
        |> JP.required "willValidate" JD.bool
        |> Data


validationMessage : Pipe Entry String a
validationMessage (Data dec) =
    dec
        |> JP.required "validationMessage" JD.string
        |> Data


validity : Pipe Entry Validity b
validity (Data dec) =
    dec
        |> JP.required "validity"
            (JD.succeed Validity
                |> JP.required "badInput" JD.bool
                |> JP.required "customError" JD.bool
                |> JP.required "patternMismatch" JD.bool
                |> JP.required "rangeOverflow" JD.bool
                |> JP.required "rangeUnderflow" JD.bool
                |> JP.required "stepMismatch" JD.bool
                |> JP.required "tooLong" JD.bool
                |> JP.required "tooShort" JD.bool
                |> JP.required "typeMismatch" JD.bool
                |> JP.required "valid" JD.bool
                |> JP.required "valueMissing" JD.bool
            )
        |> Data


type alias Validity =
    { badInput : Bool
    , customError : Bool
    , patternMismatch : Bool
    , rangeOverflow : Bool
    , rangeUnderflow : Bool
    , stepMismatch : Bool
    , tooLong : Bool
    , tooShort : Bool
    , typeMismatch : Bool
    , valid : Bool
    , valueMissing : Bool
    }
