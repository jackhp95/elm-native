module Form exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Native
import Native.Entry as Entry
import Native.Form as Form
import Native.Internal as Native exposing (Entry, Form, Window)
import Native.Window as Window


type alias Model =
    { init : Application
    , current : Application
    }


type alias Flags =
    { searchParams : Application }


initialModel : Flags -> ( Model, Cmd Msg )
initialModel { searchParams } =
    ( Model searchParams [], Cmd.none )


type Msg
    = FormChange Application


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormChange list ->
            ( { model | current = Debug.log "internal" list }, Cmd.none )


view : Model -> Html Msg
view model =
    -- Key ["index", "name", "id"]
    div [ class "flex flex-wrap" ]
        [ Html.form
            [ class "w-min flex-auto flex flex-wrap gap-2 p-4"
            , Native.onChange application (List.concat >> FormChange)
            , Native.onSubmit application (List.concat >> FormChange)
            ]
            [ fieldset [ class "flex-auto p-2 rounded border" ]
                [ legend [] [ text "Choose your favorite monster" ]
                , input
                    [ type_ "radio"
                    , id "kraken"
                    , value "kraken"
                    , name "monster"
                    ]
                    []
                , label [ for "kraken" ] [ text "Kraken" ]
                , br [] []
                , input
                    [ type_ "radio"
                    , id "sasquatch"
                    , value "sasquatch"
                    , name "monster"
                    ]
                    []
                , label [ for "sasquatch" ] [ text "Sasquatch" ]
                , br [] []
                , input
                    [ type_ "radio"
                    , id "mothman"
                    , value "mothman"
                    , name "monster"
                    ]
                    []
                , label [ for "mothman" ] [ text "Mothman" ]
                ]
            , fieldset [ class "flex-auto p-2 rounded border" ]
                [ legend [] [ text "What snacks do you like?" ]
                , input
                    [ type_ "checkbox"
                    , id "fruit"
                    , value "fruit"
                    , name "snacks"
                    ]
                    []
                , label [ for "fruit" ] [ text "Fruit" ]
                , br [] []
                , input
                    [ type_ "checkbox"
                    , id "veggies"
                    , value "veggies"
                    , name "snacks"
                    ]
                    []
                , label [ for "veggies" ] [ text "Veggies" ]
                , br [] []
                , input
                    [ type_ "checkbox"
                    , id "candy"
                    , value "candy"
                    , name "snacks"
                    ]
                    []
                , label [ for "candy" ] [ text "Candy" ]
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "input[type='text'][list]" ], input [ type_ "text", name "input[type='text'][list]", list "datalist" ] [] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "input[type='file'][multiple]" ], input [ type_ "file", name "input[type='file'][multiple]", multiple True ] [] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "input[type='email'][multiple]" ], input [ type_ "email", name "input[type='email'][multiple]", multiple True ] [] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "select[multiple]" ]
                , select [ name "select[multiple]", multiple True ]
                    [ option
                        []
                        [ text "1st text" ]
                    , option
                        []
                        [ text "2nd text" ]
                    , option
                        []
                        [ text "3rd text" ]
                    , option
                        []
                        [ text "4th text" ]
                    ]
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input" ]
                , input
                    [ name "input"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='button']" ]
                , input
                    [ name "input[type='button']"
                    , type_ "button"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='button'][value]" ]
                , input
                    [ name "input[type='button'][value]"
                    , value "input[type='button'][value]"
                    , type_ "button"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='checkbox']" ]
                , input
                    [ name "input[type='checkbox']"
                    , type_ "checkbox"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='color']" ]
                , input
                    [ name "input[type='color']"
                    , type_ "color"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='date']" ]
                , input
                    [ name "input[type='date']"
                    , type_ "date"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='datetime']" ]
                , input
                    [ name "input[type='datetime']"
                    , type_ "datetime-local"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='email']" ]
                , input
                    [ name "input[type='email']"
                    , type_ "email"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "input[type='file']" ], input [ name "input[type='file']", type_ "file" ] [] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='hidden']" ]
                , input
                    [ name "input[type='hidden']"
                    , type_ "hidden"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='image']" ]
                , input
                    [ name "input[type='image']"
                    , type_ "image"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='month']" ]
                , input
                    [ name "input[type='month']"
                    , type_ "month"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='number']" ]
                , input
                    [ name "input[type='number']"
                    , type_ "number"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='password']" ]
                , input
                    [ name "input[type='password']"
                    , type_ "password"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='radio']" ]
                , input
                    [ name "input[type='radio']"
                    , type_ "radio"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='range']" ]
                , input
                    [ name "input[type='range']"
                    , type_ "range"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='reset']" ]
                , input
                    [ name "input[type='reset']"
                    , type_ "reset"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='search']" ]
                , input
                    [ name "input[type='search']"
                    , type_ "search"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='submit']" ]
                , input
                    [ name "input[type='submit']"
                    , type_ "submit"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='tel']" ]
                , input
                    [ name "input[type='tel']"
                    , type_ "tel"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='text']" ]
                , input
                    [ name "input[type='text']"
                    , type_ "text"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='time']" ]
                , input
                    [ name "input[type='time']"
                    , type_ "time"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='url']" ]
                , input
                    [ name "input[type='url']"
                    , type_ "url"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "input[type='week']" ]
                , input
                    [ name "input[type='week']"
                    , type_ "week"
                    ]
                    []
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "output" ]
                , output
                    [ name "output"
                    ]
                    [ text "output[contents]" ]
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "object" ]
                , object
                    [ name "object"
                    ]
                    [ text "object[contents]" ]
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "select" ]
                , select [ name "select" ]
                    [ option
                        []
                        [ text "1st text" ]
                    , option
                        []
                        [ text "2nd text" ]
                    , option
                        []
                        [ text "3rd text" ]
                    , option
                        []
                        [ text "4th text" ]
                    ]
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ]
                [ label [] [ text "textarea" ]
                , textarea [ name "textarea" ]
                    [ text "textarea[contents]" ]
                ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "button" ], button [] [ text "button" ] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "button[name]" ], button [ name "button[name]" ] [ text "button[name]" ] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "button[name][type='button']" ], button [ type_ "button", name "button[name][type='button']" ] [ text "button[name][type='button']" ] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "button[name][type='reset']" ], button [ type_ "reset", name "button[name][type='reset']" ] [ text "button[name][type='reset']" ] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "button[name][type='submit']" ], button [ type_ "submit", name "button[name][type='submit']" ] [ text "button[name][type='submit']" ] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "button[name][value][type='button']" ], button [ type_ "button", name "button[name][value][type='button']", value "button[name][value][type='button']" ] [ text "button[value][type='button']" ] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "button[name][value][type='reset']" ], button [ type_ "reset", name "button[name][value][type='reset']", value "button[name][value][type='reset']" ] [ text "button[value][type='reset']" ] ]
            , div [ class "flex-auto flex flex-col p-2 rounded border" ] [ label [] [ text "button[name][value][type='submit']" ], button [ type_ "submit", name "button[name][value][type='submit']", value "button[name][value][type='submit']" ] [ text "button[value][type='submit']" ] ]
            , datalist [ id "datalist" ]
                [ option
                    []
                    [ text "1st text" ]
                , option
                    []
                    [ text "2nd text" ]
                , option
                    []
                    [ text "3rd text" ]
                , option
                    []
                    [ text "4th text" ]
                ]
            ]
        , div [ class "w-48 flex-auto bg-gray-300 p-4" ]
            [ output [ class "sticky top-4 whitespace-pre font-mono" ]
                [ text "Query Values \n? "
                , model.init
                    |> encodeApplication
                    |> text
                ]
            ]
        , div [ class "w-48 flex-auto bg-gray-300 p-4" ]
            [ output [ class "sticky top-4 whitespace-pre font-mono" ]
                [ text "Current Values \n? "
                , model.current
                    |> encodeApplication
                    |> text
                ]
            ]
        ]


main : Program Flags Model Msg
main =
    Browser.element
        { init = initialModel
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }



-- Enctype


application : Native.Node Entry (List Application)
application =
    Entry.formEntries asApplication


multipart : ()
multipart =
    ()


plainText : String
plainText =
    ""



--  EXAMPLES


type alias Application =
    List ( String, String )


encodeApplication : Application -> String
encodeApplication =
    List.map (\( name, value ) -> String.join "\n    =" [ name, value ]) >> String.join "\n& "


asApplication : Native.Data Entry Application
asApplication =
    Native.succeed
        (\name value type_ textContent tag checked multiple isActiveElement disabled files selectMultiple ->
            if disabled then
                []

            else
                case tag of
                    "SELECT" ->
                        if Maybe.withDefault False multiple then
                            -- select[multiple]
                            List.map (Tuple.pair name) selectMultiple

                        else
                            -- select
                            [ ( name, value ) ]

                    "TEXTAREA" ->
                        [ ( name, value ) ]

                    "BUTTON" ->
                        if (type_ == "submit") && isActiveElement && (not << String.isEmpty) name then
                            [ ( name, value ) ]

                        else
                            []

                    "INPUT" ->
                        if List.any ((==) type_) [ "radio", "checkbox" ] then
                            if Maybe.withDefault False checked then
                                if String.isEmpty value then
                                    [ ( name, "on" ) ]

                                else
                                    [ ( name, value ) ]

                            else
                                []

                        else if List.member type_ [ "reset", "button", "submit" ] then
                            []

                        else if type_ == "file" && Maybe.withDefault False multiple then
                            if List.isEmpty files then
                                [ ( name, value ) ]

                            else
                                List.map (Tuple.pair name) files

                        else
                            [ ( name, value ) ]

                    _ ->
                        []
        )
        |> Entry.name
        |> Entry.value
        |> Entry.type_
        |> Entry.textContent
        |> Entry.tagName
        |> Entry.checked
        |> Entry.multiple
        |> Entry.isActiveElement
        |> Entry.disabled
        |> Native.custom
            (Native.oneOf
                [ Native.collection (Native.field "name" Native.string)
                    |> Native.field "files"
                , Native.succeed []
                ]
            )
        |> Native.custom
            (Native.oneOf
                [ Native.collection (Native.map2 Tuple.pair (Native.field "selected" Native.bool) (Native.field "value" Native.string))
                    |> Native.map
                        (List.filterMap
                            (\( selected, value ) ->
                                if selected then
                                    Just value

                                else
                                    Nothing
                            )
                        )
                , Native.succeed []
                ]
            )
