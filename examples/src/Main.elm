module Main exposing (main)

import Browser exposing (..)
import Browser.Navigation as Nav
import Form
import Html exposing (..)
import Html.Attributes exposing (..)
import Native.Window as Window
import Url exposing (Url)
import Window


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

        UrlChanged _ ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Elm-Native Examples"
    , body =
        [ nav [ class "container-fluid" ]
            [ ul []
                [ li []
                    [ a [ href "/", attribute "aria-label" "Back home", class "h-full flex text-slate-800 gap-2 items-center p-4 font-bold tracking-wide" ]
                        [ img [ src "/elm-form-logo.svg", alt "elm native logo", class "w-auto h-[1em] scale-125 origin-bottom" ] []
                        , text "Elm-Native"
                        ]
                    ]
                ]
            , ul []
                [ li [] [ a [ href "https://github.com/jackhp95/elm-native", class "contrast", attribute "aria-label" "GitHub repository" ] [ img [ class "h-[1em]", src "https://api.iconify.design/mdi:github.svg", alt "Github" ] [] ] ]
                ]
            ]
        , main_ [ class "container" ]
            [ section []
                [ node "hgroup" []
                    [ h1 [] [ text "Forms" ]
                    , h2 [] [ text "All form events are fully responsive in pure semantic HTML, allowing forms to scale gracefully across devices and viewports." ]
                    ]
                , article [ id "FormExample", attribute "aria-label" "Form example" ]
                    [ Html.map FormUpdate (Form.view model.form) ]
                ]
            , section []
                [ h1 [] [ text "Window" ]
                , article [ id "WindowExample", attribute "aria-label" "Window example" ]
                    [ Html.map WindowUpdate (Window.view model.window) ]
                ]
            ]
        ]
    }
