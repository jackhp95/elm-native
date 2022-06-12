module Main exposing (main)

import Browser
import Form
import HelloWorld exposing (helloWorld)
import Html exposing (Html, div, img)
import Html.Attributes exposing (src, style)
import Msg exposing (Msg(..))
import Window



-- main : Program () Int Msg


main =
    Form.main
    -- Window.main


update : Msg -> number -> number
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view : Int -> Html Msg
view model =
    div []
        [ img [ src "/logo.png", style "width" "300px" ] []
        , helloWorld model
        ]
