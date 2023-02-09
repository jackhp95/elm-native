module Main exposing (main)

import Browser exposing (..)
import Browser.Navigation as Nav
import Form
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode
import Json.Encode
import Msg exposing (Msg(..))
import Native.Window as Window
import Url exposing (Url)
import Window



-- main : Program () Int Msg


type alias Model =
    { window : Window.Model, form : Form.Model, key : Nav.Key }


initialModel : Window.FlagArg -> Url -> Nav.Key -> ( Model, Cmd Msg )
initialModel flags url navKey =
    let
        ( form, formCmds ) =
            Form.initialModel { window = Window.fromFlag flags }
                |> Tuple.mapSecond (Cmd.map FormUpdate)

        ( window, windowCmds ) =
            Window.initialModel flags
                |> Tuple.mapSecond (Cmd.map WindowUpdate)
    in
    ( Model window form navKey, Cmd.batch [ windowCmds, formCmds ] )


main : Program Window.FlagArg Model Msg
main =
    Browser.application
        { init = initialModel
        , view = view
        , subscriptions = always Sub.none
        , update = update
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }



-- Window.main


type Msg
    = FormUpdate Form.Msg
    | WindowUpdate Window.Msg
    | UrlChanged Url
    | UrlRequested Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FormUpdate formMsg ->
            Form.update formMsg model.form
                |> Tuple.mapBoth (\form -> { model | form = form }) (Cmd.map FormUpdate)

        WindowUpdate windowMsg ->
            Window.update windowMsg model.window
                |> Tuple.mapBoth (\window -> { model | window = window }) (Cmd.map WindowUpdate)

        UrlRequested urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Hello Application"
    , body =
        [ nav [ class "container-fluid" ]
            [ ul []
                [ li []
                    [ a [ href "/", attribute "aria-label" "Back home", class "h-full flex text-slate-800 gap-2 items-center p-4 font-bold tracking-wide" ]
                        [ img [ src "/elm-form-logo.svg", alt "elm native logo", class "w-auto h-[1em] scale-125 origin-bottom" ]
                            []
                        , text "Elm-Native"
                        ]
                    ]
                , li [] [ text "Documentation" ]
                ]
            , ul []
                [ li [] [ a [ href "#examples", class "secondary" ] [ text "Examples" ] ]
                , li [] [ a [ href "./", class "secondary" ] [ text "Docs" ] ]
                , li [] [ a [ href "https://github.com/jackhp95/elm-native", class "contrast", attribute "aria-label" "Pico GitHub repository" ] [ img [ class "h-[1em]", src "https://api.iconify.design/mdi:github.svg", alt "Github" ] [] ] ]
                ]
            ]
        , main_ [ class "container overflow-x-hidden", id "docs" ]
            [ aside []
                [ nav [ class "closed-on-mobile" ]
                    [ a [ href "./", class "secondary", id "toggle-docs-navigation" ] [ text "Table of content" ]
                    , details []
                        [ summary [] [ text "Getting started" ]
                        , ul []
                            [ li [] [ a [ href "./", id "start-link", class "secondary" ] [ text "Usage" ] ]
                            , li [] [ a [ href "#themes", id "themes-link", class "secondary" ] [ text "Themes" ] ]
                            , li [] [ a [ href "#customization", id "customization-link", class "secondary" ] [ text "Customization" ] ]
                            , li [] [ a [ href "#classless", id "classless-link", class "secondary" ] [ text "Class-less version" ] ]
                            , li [] [ a [ href "#rtl", id "rtl-link", class "secondary" ] [ text "RTL" ] ]
                            ]
                        ]
                    , details []
                        [ summary [] [ text "Layout" ]
                        , ul []
                            [ li [] [ a [ href "#containers", id "containers-link", class "secondary" ] [ text "Containers" ] ]
                            , li [] [ a [ href "#grid", id "grid-link", class "secondary" ] [ text "Grid" ] ]
                            , li [] [ a [ href "#scroller", id "scroller-link", class "secondary" ] [ text "Horizontal scroller" ] ]
                            ]
                        ]
                    , details [ attribute "open" "true" ]
                        [ summary [] [ text "Events" ]
                        , ul []
                            [ li [] [ a [ href "#typography", id "typography-link", class "secondary" ] [ text "Typography" ] ]
                            , li [] [ a [ href "#buttons", id "buttons-link", class "secondary" ] [ text "Buttons" ] ]
                            , li [] [ a [ href "#FormExample", id "forms-link", class "secondary", attribute "aria-current" "page" ] [ text "Forms" ] ]
                            , li [] [ a [ href "#WindowExample", id "tables-link", class "secondary" ] [ text "Window" ] ]
                            ]
                        ]
                    , details []
                        [ summary [] [ text "Components" ]
                        , ul []
                            [ li [] [ a [ href "#accordions", id "accordions-link", class "secondary" ] [ text "Accordions" ] ]
                            , li [] [ a [ href "#cards", id "cards-link", class "secondary" ] [ text "Cards" ] ]
                            , li [] [ a [ href "#dropdowns", id "dropdowns-link", class "secondary" ] [ text "Dropdowns" ] ]
                            , li [] [ a [ href "#modal", id "modal-link", class "secondary" ] [ text "Modal" ] ]
                            , li [] [ a [ href "#navs", id "navs-link", class "secondary" ] [ text "Navs" ] ]
                            , li [] [ a [ href "#progress", id "progress-link", class "secondary" ] [ text "Progress" ] ]
                            ]
                        ]
                    , details []
                        [ summary [] [ text "Utilities" ]
                        , ul []
                            [ li [] [ a [ href "#loading", id "loading-link", class "secondary" ] [ text "Loading" ] ]
                            , li [] [ a [ href "#tooltips", id "tooltips-link", class "secondary" ] [ text "Tooltips" ] ]
                            ]
                        ]
                    , details []
                        [ summary [] [ text "Extend" ]
                        , ul []
                            [ li [] [ a [ href "./we-lov#classes", id "we-love-classes-link", class "secondary" ] [ text "We love .classes" ] ] ]
                        ]
                    ]
                ]
            , div [ attribute "role" "document" ]
                [ section [ id "forms" ]
                    [ node "hgroup"
                        []
                        [ h1 [] [ text "Forms" ], h2 [] [ text "All form events are fully responsive in pure semantic HTML, allowing forms to scale gracefully across devices and viewports." ] ]
                    , p [] [ text "Inputs are", code [] [ i [] [ text "width" ], text ":", u [] [ text "100%" ], text ";" ], text "by default. You can use", code [] [ text ".grid" ], text "inside a form." ]
                    , p [] [ text "All natives form events are fully customizable and themeable with CSS variables." ]
                    , article [ id "FormExample", attribute "aria-label" "Form example" ] [ Html.map FormUpdate (Form.view model.form) ]
                    , article [ id "WindowExample", attribute "aria-label" "Window example" ] [ Html.map WindowUpdate (Window.view model.window) ]
                    , p [] [ text "Disabled and validation states:" ]
                    , article [ attribute "aria-label" "Validation states examples" ]
                        [ Html.form [ class "grid" ]
                            [ input [ type_ "text", placeholder "Valid", attribute "aria-label" "Valid", attribute "aria-invalid" "false" ]
                                []
                            , input [ type_ "text", placeholder "Invalid", attribute "aria-label" "Invalid", attribute "aria-invalid" "true" ]
                                []
                            , input [ type_ "text", placeholder "Disabled", attribute "aria-label" "Disabled", disabled True ]
                                []
                            , input [ type_ "text", value "Readonly", attribute "aria-label" "Readonly", readonly True ]
                                []
                            ]
                        , footer [ class "code" ]
                            [ pre []
                                []
                            ]
                        ]
                    , p [] [ code [] [ text "<", b [] [ text "fieldset" ], text ">" ], text "is unstyled and acts as a container for radios and checkboxes, providing a consistent", code [] [ i [] [ text "margin-bottom" ] ], text "for the set." ]
                    , p [] [ text "enable a custom switch." ]
                    , article [ attribute "aria-label" "Select, radios, checkboxes, switch examples" ]
                        [ label [ for "fruit" ] [ text "Fruit" ]
                        , select [ id "fruit", required True ] [ option [ value "", selected True ] [ text "Select a fruit…" ], option [] [ text "Banana" ], option [] [ text "Watermelon" ], option [] [ text "Apple" ], option [] [ text "Orange" ], option [] [ text "Mango" ] ]
                        , fieldset []
                            [ legend [] [ text "Size" ]
                            , label [ for "small" ]
                                [ input [ type_ "radio", id "small", name "size", value "small", checked True ]
                                    []
                                , text "Small"
                                ]
                            , label [ for "medium" ]
                                [ input [ type_ "radio", id "medium", name "size", value "medium" ]
                                    []
                                , text "Medium"
                                ]
                            , label [ for "large" ]
                                [ input [ type_ "radio", id "large", name "size", value "large" ]
                                    []
                                , text "Large"
                                ]
                            , label [ for "extralarge" ]
                                [ input [ type_ "radio", id "extralarge", name "size", value "extralarge", disabled True ]
                                    []
                                , text "Extra Large"
                                ]
                            ]
                        , fieldset []
                            [ label [ for "terms" ]
                                [ input [ type_ "checkbox", id "terms", name "terms" ]
                                    []
                                , text "I agree to the Terms and Conditions"
                                ]
                            , label [ for "terms_sharing" ]
                                [ input [ type_ "checkbox", id "terms_sharing", name "terms_sharing", disabled True, checked True ]
                                    []
                                , text "I agree to share my information with partners"
                                ]
                            ]
                        , fieldset []
                            [ label [ for "switch" ]
                                [ input [ type_ "checkbox", id "switch", name "switch", attribute "role" "switch" ]
                                    []
                                , text "Publish on my profile"
                                ]
                            , label [ for "switch_disabled" ]
                                [ input [ type_ "checkbox", id "switch_disabled", name "switch_disabled", attribute "role" "switch", disabled True, checked True ]
                                    []
                                , text "User must change password at next logon"
                                ]
                            ]
                        , footer [ class "code" ]
                            []
                        ]
                    , p [] [ text "You can change a checkbox to an indeterminate state by setting the", code [] [ i [] [ text "indeterminate" ] ], text "property to", code [] [ u [] [ text "true" ] ] ]
                    , article [ attribute "aria-label" "Indeterminate checkbox example" ]
                        [ label [ for "indeterminate-checkbox" ]
                            [ input [ type_ "checkbox", id "indeterminate-checkbox", name "indeterminate-checkbox", Html.Attributes.property "indeterminate" (Json.Encode.bool True) ]
                                []
                            , text "Select all"
                            ]
                        ]
                    , p [] [ text "Others input types:" ]
                    , article [ attribute "aria-label" "Search, file browser, range slider, date, time, color examples" ]
                        [ input [ type_ "search", id "search", name "search", placeholder "Search" ]
                            []
                        , label [ for "file" ]
                            [ text "File browser"
                            , input [ type_ "file", id "file", name "file" ]
                                []
                            ]
                        , label [ for "range" ]
                            [ text "Range slider"
                            , input [ type_ "range", value "50", id "range", name "range" ]
                                []
                            ]
                        , label [ for "date" ]
                            [ text "Date"
                            , input [ type_ "date", id "date", name "date" ]
                                []
                            ]
                        , label [ for "time" ]
                            [ text "Time"
                            , input [ type_ "time", id "time", name "time" ]
                                []
                            ]
                        , label [ for "color" ]
                            [ text "Color"
                            , input [ type_ "color", id "color", name "color", value "#0eaaaa" ]
                                []
                            ]
                        , footer [ class "code" ]
                            []
                        ]
                    ]
                , footer []
                    [ hr []
                        []
                    , p [] [ small [] [ text "Code licensed", a [ href "https://github.com/picocss/pico/blob/master/LICENSE.md", class "secondary" ] [ text "MIT" ] ] ]
                    ]

                -- , button
                --     [ class "contrast switcher theme-switcher"
                --     , attribute "aria-label" "Turn off dark mode"
                --     ]
                --     [ i [] [ text "Turn off dark mode" ]
                --     ]
                ]
            ]
        ]
    }
