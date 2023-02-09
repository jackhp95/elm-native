module Form exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Native
import Native.Enctype as Enctype
import Native.Enctype.SearchParams as SearchParams exposing (SearchParams)
import Native.Entry as Entry
import Native.Form as Form
import Native.Internal as Native exposing (Entry, Form, Window)
import Native.Window as Window


type alias Model =
    { init : SearchParams
    , current : SearchParams
    }


initialModel : { x | window : Native.Persist } -> ( Model, Cmd Msg )
initialModel { window } =
    let
        initApplication =
            window
                |> Native.decode (Window.window (Native.succeed identity |> Window.location))
                |> Result.toMaybe
                |> Maybe.map SearchParams.fromUrl
                |> Maybe.withDefault []
    in
    ( Model initApplication [], Cmd.none )


type Msg
    = FormChange SearchParams


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormChange list ->
            ( { model | current = list }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "grid" ]
        [ Html.form
            [ Native.onChange Enctype.application FormChange
            , if List.isEmpty (List.filter (Tuple.first >> (==) "disable_GET") model.current) then
                class ""

              else
                Native.onSubmit Enctype.application FormChange
            ]
            [ fieldset [] [ legend [] [ text "Disable GET request on Submit" ], input [ type_ "checkbox", name "disable_GET" ] [] ]
            , fieldset [] [ legend [] [ text "Choose your favorite monster" ], input [ type_ "radio", id "kraken", value "kraken", name "monster" ] [], label [ for "kraken" ] [ text "Kraken" ], br [] [], input [ type_ "radio", id "sasquatch", value "sasquatch", name "monster" ] [], label [ for "sasquatch" ] [ text "Sasquatch" ], br [] [], input [ type_ "radio", id "mothman", value "mothman", name "monster" ] [], label [ for "mothman" ] [ text "Mothman" ] ]
            , fieldset [] [ legend [] [ text "What snacks do you like?" ], input [ type_ "checkbox", id "fruit", value "fruit", name "snacks" ] [], label [ for "fruit" ] [ text "Fruit" ], br [] [], input [ type_ "checkbox", id "veggies", value "veggies", name "snacks" ] [], label [ for "veggies" ] [ text "Veggies" ], br [] [], input [ type_ "checkbox", id "candy", value "candy", name "snacks" ] [], label [ for "candy" ] [ text "Candy" ] ]
            , div [] [ label [] [ text "input[type='text'][list]" ], input [ type_ "text", name "input[type='text'][list]", list "datalist" ] [] ]
            , div [] [ label [] [ text "input[type='file'][multiple]" ], input [ type_ "file", name "input[type='file'][multiple]", multiple True ] [] ]
            , div [] [ label [] [ text "input[type='email'][multiple]" ], input [ type_ "email", name "input[type='email'][multiple]", multiple True ] [] ]
            , div [] [ label [] [ text "select[multiple]" ], select [ name "select[multiple]", multiple True ] [ option [] [ text "1st text" ], option [] [ text "2nd text" ], option [] [ text "3rd text" ], option [] [ text "4th text" ] ] ]
            , div [] [ label [] [ text "input" ], input [ name "input" ] [] ]
            , div [] [ label [] [ text "input[type='button']" ], input [ name "input[type='button']", type_ "button" ] [] ]
            , div [] [ label [] [ text "input[type='button'][value]" ], input [ name "input[type='button'][value]", value "input[type='button'][value]", type_ "button" ] [] ]
            , div [] [ label [] [ text "input[type='checkbox']" ], input [ name "input[type='checkbox']", type_ "checkbox" ] [] ]
            , div [] [ label [] [ text "input[type='color']" ], input [ name "input[type='color']", type_ "color" ] [] ]
            , div [] [ label [] [ text "input[type='date']" ], input [ name "input[type='date']", type_ "date" ] [] ]
            , div [] [ label [] [ text "input[type='datetime']" ], input [ name "input[type='datetime']", type_ "datetime-local" ] [] ]
            , div [] [ label [] [ text "input[type='email']" ], input [ name "input[type='email']", type_ "email" ] [] ]
            , div [] [ label [] [ text "input[type='file']" ], input [ name "input[type='file']", type_ "file" ] [] ]
            , div [] [ label [] [ text "input[type='hidden']" ], input [ name "input[type='hidden']", type_ "hidden" ] [] ]
            , div [] [ label [] [ text "input[type='image']" ], input [ name "input[type='image']", type_ "image", src "/elm-form-logo.svg" ] [] ]
            , div [] [ label [] [ text "input[type='month']" ], input [ name "input[type='month']", type_ "month" ] [] ]
            , div [] [ label [] [ text "input[type='number']" ], input [ name "input[type='number']", type_ "number" ] [] ]
            , div [] [ label [] [ text "input[type='password']" ], input [ name "input[type='password']", type_ "password" ] [] ]
            , div [] [ label [] [ text "input[type='radio']" ], input [ name "input[type='radio']", type_ "radio" ] [] ]
            , div [] [ label [] [ text "input[type='range']" ], input [ name "input[type='range']", type_ "range" ] [] ]
            , div [] [ label [] [ text "input[type='reset']" ], input [ name "input[type='reset']", type_ "reset" ] [] ]
            , div [] [ label [] [ text "input[type='search']" ], input [ name "input[type='search']", type_ "search" ] [] ]
            , div [] [ label [] [ text "input[type='submit']" ], input [ name "input[type='submit']", type_ "submit" ] [] ]
            , div [] [ label [] [ text "input[type='tel']" ], input [ name "input[type='tel']", type_ "tel" ] [] ]
            , div [] [ label [] [ text "input[type='text']" ], input [ name "input[type='text']", type_ "text" ] [] ]
            , div [] [ label [] [ text "input[type='time']" ], input [ name "input[type='time']", type_ "time" ] [] ]
            , div [] [ label [] [ text "input[type='url']" ], input [ name "input[type='url']", type_ "url" ] [] ]
            , div [] [ label [] [ text "input[type='week']" ], input [ name "input[type='week']", type_ "week" ] [] ]
            , div [] [ label [] [ text "output" ], output [ name "output" ] [ text "output[contents]" ] ]
            , div [] [ label [] [ text "object" ], object [ name "object" ] [ text "object[contents]" ] ]
            , div [] [ label [] [ text "select" ], select [ name "select" ] [ option [] [ text "1st text" ], option [] [ text "2nd text" ], option [] [ text "3rd text" ], option [] [ text "4th text" ] ] ]
            , div [] [ label [] [ text "textarea" ], textarea [ name "textarea" ] [ text "textarea[contents]" ] ]
            , div [] [ label [] [ text "button" ], button [] [ text "button" ] ]
            , div [] [ label [] [ text "button[name]" ], button [ name "button[name]" ] [ text "button[name]" ] ]
            , div [] [ label [] [ text "button[name][type='button']" ], button [ type_ "button", name "button[name][type='button']" ] [ text "button[name][type='button']" ] ]
            , div [] [ label [] [ text "button[name][type='reset']" ], button [ type_ "reset", name "button[name][type='reset']" ] [ text "button[name][type='reset']" ] ]
            , div [] [ label [] [ text "button[name][type='submit']" ], button [ type_ "submit", name "button[name][type='submit']" ] [ text "button[name][type='submit']" ] ]
            , div [] [ label [] [ text "button[name][value][type='button']" ], button [ type_ "button", name "button[name][value][type='button']", value "button[name][value][type='button']" ] [ text "button[value][type='button']" ] ]
            , div [] [ label [] [ text "button[name][value][type='reset']" ], button [ type_ "reset", name "button[name][value][type='reset']", value "button[name][value][type='reset']" ] [ text "button[value][type='reset']" ] ]
            , div [] [ label [] [ text "button[name][value][type='submit']" ], button [ type_ "submit", name "button[name][value][type='submit']", value "button[name][value][type='submit']" ] [ text "button[value][type='submit']" ] ]
            , datalist [ id "datalist" ] [ option [] [ text "1st text" ], option [] [ text "2nd text" ], option [] [ text "3rd text" ], option [] [ text "4th text" ] ]
            ]
        -- , div [] [ output [] [ text "Query Values \n? ", model.init |> SearchParams.toString |> text ] ]
        -- , div [] [ output [] [ text "Current Values \n? ", model.current |> SearchParams.toString |> text ] ]
        ]
