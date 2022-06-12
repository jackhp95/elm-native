module Native exposing (..)

import Html exposing (Attribute)
import Html.Events as Events exposing (custom)
import Json.Decode as JD
import Native.Entry as Entry exposing (..)
import Native.Form as Form exposing (..)
import Native.Internal as Internal exposing (..)
import Native.Window as Window exposing (..)


decode : Node Window a -> Persist -> Result JD.Error a
decode (Node decoder) (Persist value) =
    JD.decodeValue decoder value



-- --------- --
-- Listeners --
-- --------- --
-- Custom


on : String -> Node native a -> (a -> msg) -> Attribute msg
on event (Node decoder) msg =
    decoder
        |> JD.map
            (\result ->
                { message = msg result
                , stopPropagation = True
                , preventDefault = True
                }
            )
        |> Events.custom event



-- Entry


onInput : Node native a -> (a -> msg) -> Attribute msg
onInput =
    on "input"


onChange : Node native a -> (a -> msg) -> Attribute msg
onChange =
    on "change"



-- Form


onSubmit : Node native a -> (a -> msg) -> Attribute msg
onSubmit =
    on "submit"


onReset : Node native a -> (a -> msg) -> Attribute msg
onReset =
    on "reset"



-- Focus


onFocus : Node native a -> (a -> msg) -> Attribute msg
onFocus =
    on "focus"


onBlur : Node native a -> (a -> msg) -> Attribute msg
onBlur =
    on "blur"
