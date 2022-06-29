module Window exposing (..)

import Browser
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Maybe.Extra
import Native
import Native.Entry as Entry
import Native.Form as Form
import Native.Internal as Native exposing (Entry, Form, Window)
import Native.Window as Window
import Url exposing (Url)


type alias Model =
    Maybe WindowExample


initialModel : flags -> ( Model, Cmd Msg )
initialModel _ =
    ( Nothing, Cmd.none )


type Msg
    = GotWindow WindowExample


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotWindow window ->
            ( Just window, Cmd.none )


tf : Bool -> String
tf bool =
    if bool then
        "True"

    else
        "False"


view : Model -> Html Msg
view model =
    Html.form []
        [ button
            [ type_ "button"
            , Native.on "click" (Window.window windowExample) GotWindow
            ]
            [ text "Get Window Data" ]
        , case model of
            Just window ->
                div []
                    [ h2 []
                        [ text "location" ]
                    , p [] [ text (Url.toString window.location) ]
                    , h2 []
                        [ text "NetworkInformation" ]
                    , dl []
                        [ dt [] [ text "downlink " ]
                        , dd [] [ text (String.fromFloat window.networkInformation.downlink) ]
                        , dt [] [ text "effectiveType " ]
                        , dd [] [ text window.networkInformation.effectiveType ]
                        , dt [] [ text "rtt " ]
                        , dd [] [ text (String.fromFloat window.networkInformation.rtt) ]
                        , dt [] [ text "saveData " ]
                        , dd [] [ text (tf window.networkInformation.saveData) ]
                        ]
                    , h2 [] [ text "LocalStorage" ]
                    , window.localStorage
                        |> Dict.toList
                        |> List.concatMap (\( k, v ) -> [ dt [] [ text k ], dd [] [ text v ] ])
                        |> dl []
                    , h2 [] [ text "About Device" ]
                    , dl []
                        [ dt [] [ text "onLine" ]
                        , dd [] [ text (tf window.onLine) ]
                        , dt [] [ text "userAgent" ]
                        , dd [] [ text window.userAgent ]
                        , dt [] [ text "deviceMemory" ]
                        , dd [] [ text (String.fromInt window.deviceMemory) ]
                        , dt [] [ text "doNotTrack" ]
                        , dd []
                            [ text
                                (window.doNotTrack
                                    |> Maybe.map tf
                                    |> Maybe.withDefault "Unspecified"
                                )
                            ]
                        , dt [] [ text "hardwareConcurrency" ]
                        , dd [] [ text (String.fromInt window.hardwareConcurrency) ]
                        , dt [] [ text "language" ]
                        , dd [] [ text window.language ]
                        , dt [] [ text "languages" ]
                        , dd [] [ text (String.join ", " window.languages) ]
                        , dt [] [ text "maxTouchPoints" ]
                        , dd [] [ text (String.fromInt window.maxTouchPoints) ]
                        , dt [] [ text "pdfViewerEnabled" ]
                        , dd [] [ text (tf window.pdfViewerEnabled) ]
                        , dt [] [ text "platform" ]
                        , dd [] [ text <| window.platform ]
                        , dt [] [ text "hasBeenActive" ]
                        , dd [] [ text <| tf window.hasBeenActive ]
                        , dt [] [ text "isActive" ]
                        , dd [] [ text <| tf window.isActive ]
                        , dt [] [ text "userAgentData.mobile" ]
                        , dd [] [ text <| tf window.userAgentData.mobile ]
                        , dt [] [ text "userAgentData.platform" ]
                        , dd [] [ text <| window.userAgentData.platform ]
                        , dt [] [ text "vendor" ]
                        , dd [] [ text <| window.vendor ]
                        , dt [] [ text "vendorSub" ]
                        , dd [] [ text <| window.vendorSub ]
                        , dt [] [ text "virtualKeyboard.overlaysContent" ]
                        , dd [] [ text <| tf window.virtualKeyboard.overlaysContent ]
                        , dt [] [ text "devicePixelRatio" ]
                        , dd [] [ text <| String.fromFloat window.devicePixelRatio ]
                        , dt [] [ text "locationbar" ]
                        , dd [] [ text <| tf window.locationbar ]
                        , dt [] [ text "menubar" ]
                        , dd [] [ text <| tf window.menubar ]
                        , dt [] [ text "scrollbars" ]
                        , dd [] [ text <| tf window.scrollbars ]
                        , dt [] [ text "styleMedia" ]
                        , dd [] [ text <| window.styleMedia ]
                        , dt [] [ text "toolbar" ]
                        , dd [] [ text <| tf window.toolbar ]
                        , dt [] [ text "speechSynthesis" ]
                        , dd []
                            [ dl []
                                [ dt [] [ text "paused" ]
                                , dd [] [ text <| tf window.speechSynthesis.paused ]
                                , dt [] [ text "pending" ]
                                , dd [] [ text <| tf window.speechSynthesis.pending ]
                                , dt [] [ text "speaking" ]
                                , dd [] [ text <| tf window.speechSynthesis.speaking ]
                                ]
                            ]
                        ]
                    ]

            Nothing ->
                text ""
        ]



--  EXAMPLES


type alias WindowExample =
    { location : Url
    , onLine : Bool
    , userAgent : String
    , performance : Window.Performance
    , localStorage : Dict String String
    , networkInformation : Window.NetworkInformation
    , deviceMemory : Int
    , doNotTrack : Maybe Bool
    , hardwareConcurrency : Int
    , language : String
    , languages : List String
    , maxTouchPoints : Int
    , pdfViewerEnabled : Bool
    , platform : String
    , hasBeenActive : Bool
    , isActive : Bool
    , userAgentData : Window.UserAgentData
    , vendor : String
    , vendorSub : String
    , virtualKeyboard : Window.VirtualKeyboard
    , devicePixelRatio : Float
    , locationbar : Bool
    , menubar : Bool
    , scrollbars : Bool
    , styleMedia : String
    , toolbar : Bool
    , speechSynthesis : Window.SpeechSynthesis
    }


windowExample : Native.Data Window WindowExample
windowExample =
    Native.succeed WindowExample
        |> Window.location
        |> Window.onLine
        |> Window.userAgent
        |> Window.performance
        |> Window.localStorage
        |> Window.networkInformation
        |> Window.deviceMemory
        |> Window.doNotTrack
        |> Window.hardwareConcurrency
        |> Window.language
        |> Window.languages
        |> Window.maxTouchPoints
        |> Window.pdfViewerEnabled
        |> Window.platform
        |> Window.hasBeenActive
        |> Window.isActive
        |> Window.userAgentData
        |> Window.vendor
        |> Window.vendorSub
        |> Window.virtualKeyboard
        |> Window.devicePixelRatio
        |> Window.locationbar
        |> Window.menubar
        |> Window.scrollbars
        |> Window.styleMedia
        |> Window.toolbar
        |> Window.speechSynthesis
