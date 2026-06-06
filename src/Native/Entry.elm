module Native.Entry exposing
    ( entry, concatFormEntries, formEntries, allFormEntries
    , nonEmptyString
    , isActiveElement, id, textContent, type_, tagName, name
    , formAction, formEnctype, formMethod, formNoValidate
    , isConnected, files, value, valueAsDate, valueAsInt, valueAsFloat
    , defaultValue, checked, defaultChecked, multiple
    , required, readOnly, hidden, disabled
    , willValidate, validationMessage, validity, Validity
    )

import Json.Decode as JD
import Json.Decode.Extra as JD
import Json.Decode.Pipeline as JP
import Native.Internal exposing (..)



-- Entry


entry : Data Entry a -> Node Entry a
entry =
    buildNode internalDecodeEntry


concatFormEntries : Data Entry (List a) -> Node Entry (List a)
concatFormEntries =
    buildNode
        (\dec ->
            JD.collection (JD.oneOf [ JD.map Just dec, JD.succeed Nothing ])
                |> JD.map (List.filterMap identity >> List.concat)
                |> JD.at [ "form", "elements" ]
                |> internalDecodeEntry
        )


formEntries : Data Entry a -> Node Entry (List a)
formEntries =
    buildNode
        (\dec ->
            JD.collection (JD.oneOf [ JD.map Just dec, JD.succeed Nothing ])
                |> JD.map (List.filterMap identity)
                |> JD.at [ "form", "elements" ]
                |> internalDecodeEntry
        )


allFormEntries : Data Entry a -> Node Entry (List a)
allFormEntries =
    buildNode
        (\dec ->
            JD.collection (JD.oneOf [ JD.map Just dec, JD.succeed Nothing ])
                |> JD.map (List.filterMap identity)
                |> JD.at [ "elements" ]
                |> internalDecodeAllForms
                |> JD.map List.concat
        )



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
isActiveElement =
    customPipe
        (JD.oneOf
            [ JD.map2 (==)
                (JD.at [ "ownerDocument", "activeElement", "name" ] nonEmptyString)
                (JD.field "name" nonEmptyString)
            , JD.succeed False
            ]
        )


id : Pipe Entry String a
id =
    requiredPipe "id" JD.string


textContent : Pipe Entry String a
textContent =
    requiredPipe "textContent" JD.string


type_ : Pipe Entry String a
type_ =
    requiredPipe "type" JD.string


tagName : Pipe Entry String a
tagName =
    requiredPipe "tagName" JD.string


name : Pipe Entry String a
name =
    requiredPipe "name" JD.string


formAction : Pipe Entry String a
formAction =
    requiredPipe "formAction" JD.string


formEnctype : Pipe Entry String a
formEnctype =
    requiredPipe "formEnctype" JD.string


formMethod : Pipe Entry String a
formMethod =
    requiredPipe "formMethod" JD.string


formNoValidate : Pipe Entry Bool a
formNoValidate =
    requiredPipe "formNoValidate" JD.bool


isConnected : Pipe Entry Bool a
isConnected =
    requiredPipe "isConnected" JD.bool


files : Pipe Entry JD.Value a
files =
    requiredPipe "files" JD.value


value : Pipe Entry String a
value =
    requiredPipe "value" JD.string


valueAsDate : Pipe Entry String a
valueAsDate =
    requiredPipe "valueAsDate" JD.string


valueAsInt : Pipe Entry Int a
valueAsInt =
    requiredPipe "valueAsNumber" JD.int


valueAsFloat : Pipe Entry Float a
valueAsFloat =
    requiredPipe "valueAsNumber" JD.float


defaultValue : Pipe Entry String a
defaultValue =
    requiredPipe "defaultValue" JD.string


checked : Pipe Entry (Maybe Bool) a
checked =
    optionalPipe "checked" (JD.map Just JD.bool) Nothing


defaultChecked : Pipe Entry (Maybe Bool) a
defaultChecked =
    optionalPipe "defaultChecked" (JD.map Just JD.bool) Nothing


multiple : Pipe Entry (Maybe Bool) a
multiple =
    optionalPipe "multiple" (JD.map Just JD.bool) Nothing


required : Pipe Entry Bool a
required =
    requiredPipe "required" JD.bool


readOnly : Pipe Entry Bool a
readOnly =
    requiredPipe "readOnly" JD.bool


hidden : Pipe Entry Bool a
hidden =
    requiredPipe "hidden" JD.bool


disabled : Pipe Entry Bool a
disabled =
    requiredPipe "disabled" JD.bool


willValidate : Pipe Entry Bool a
willValidate =
    requiredPipe "willValidate" JD.bool


validationMessage : Pipe Entry String a
validationMessage =
    requiredPipe "validationMessage" JD.string


validity : Pipe Entry Validity b
validity =
    requiredPipe "validity"
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
