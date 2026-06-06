module Native.Window exposing
    ( window, FlagArg, fromFlag
    , location
    , networkInformation, NetworkInformation
    , deviceMemory, doNotTrack, hardwareConcurrency
    , language, languages, maxTouchPoints, onLine
    , pdfViewerEnabled, platform, hasBeenActive, isActive
    , userAgent, userAgentData, UserAgentData
    , vendor, vendorSub
    , virtualKeyboard, VirtualKeyboard, DOMRect, domRect
    , devicePixelRatio, localStorage
    , locationbar, menubar, scrollbars, styleMedia, toolbar
    , speechSynthesis, SpeechSynthesis
    , performance, Performance, MemoryInfo, PerformanceTiming
    , memoryInfo, performanceTiming
    )

import Dict exposing (Dict)
import Json.Decode as JD
import Json.Decode.Pipeline as JP
import Maybe.Extra
import Native.Internal exposing (..)
import Url exposing (Url)



-- Window


window : Data Window a -> Node Window a
window =
    buildNode (\dec -> dec |> JD.at [ "ownerDocument", "defaultView" ] |> internalDecodeEntry)


-- Elm wraps raw JS objects passed as flags in nested { self } records.
-- Passing `window` as flags (see main.js) requires unwrapping 4 levels.
type alias FlagArg =
    { self : { self : { self : { self : JD.Value } } } }


fromFlag : FlagArg -> Persist
fromFlag flag =
    makePersist flag.self.self.self.self



-- Window Hacks


location : Pipe Window Url a
location =
    requiredAtPipe [ "location", "href" ]
        (JD.andThen (Url.fromString >> Maybe.Extra.unwrap (JD.fail "") JD.succeed) JD.string)


type alias NetworkInformation =
    { downlink : Float
    , effectiveType : String
    , rtt : Float
    , saveData : Bool
    }


networkInformation : Pipe Window NetworkInformation a
networkInformation =
    requiredAtPipe [ "navigator", "connection" ]
        (JD.map4 NetworkInformation
            (JD.field "downlink" JD.float)
            (JD.field "effectiveType" JD.string)
            (JD.field "rtt" JD.float)
            (JD.field "saveData" JD.bool)
        )


deviceMemory : Pipe Window Int a
deviceMemory =
    requiredAtPipe [ "navigator", "deviceMemory" ] JD.int


doNotTrack : Pipe Window (Maybe Bool) a
doNotTrack =
    requiredAtPipe [ "navigator", "doNotTrack" ]
        (JD.string
            |> JD.map
                (\str ->
                    case str of
                        "0" ->
                            Just False

                        "1" ->
                            Just True

                        _ ->
                            Nothing
                )
        )


hardwareConcurrency : Pipe Window Int a
hardwareConcurrency =
    requiredAtPipe [ "navigator", "hardwareConcurrency" ] JD.int


language : Pipe Window String a
language =
    requiredAtPipe [ "navigator", "language" ] JD.string


languages : Pipe Window (List String) a
languages =
    requiredAtPipe [ "navigator", "languages" ] (JD.list JD.string)


maxTouchPoints : Pipe Window Int a
maxTouchPoints =
    requiredAtPipe [ "navigator", "maxTouchPoints" ] JD.int


onLine : Pipe Window Bool a
onLine =
    requiredAtPipe [ "navigator", "onLine" ] JD.bool


pdfViewerEnabled : Pipe Window Bool a
pdfViewerEnabled =
    requiredAtPipe [ "navigator", "pdfViewerEnabled" ] JD.bool


platform : Pipe Window String a
platform =
    requiredAtPipe [ "navigator", "platform" ] JD.string


hasBeenActive : Pipe Window Bool a
hasBeenActive =
    requiredAtPipe [ "navigator", "userActivation", "hasBeenActive" ] JD.bool


isActive : Pipe Window Bool a
isActive =
    requiredAtPipe [ "navigator", "userActivation", "isActive" ] JD.bool


userAgent : Pipe Window String a
userAgent =
    requiredAtPipe [ "navigator", "userAgent" ] JD.string


type alias UserAgentData =
    { brands : List { brand : String, version : String }
    , mobile : Bool
    , platform : String
    }


userAgentData : Pipe Window UserAgentData a
userAgentData =
    requiredAtPipe [ "navigator", "userAgentData" ]
        (JD.map3 UserAgentData
            (JD.field "brands" (JD.list (JD.map2 (\b v -> { brand = b, version = v }) (JD.field "brand" JD.string) (JD.field "version" JD.string))))
            (JD.field "mobile" JD.bool)
            (JD.field "platform" JD.string)
        )


vendor : Pipe Window String a
vendor =
    requiredAtPipe [ "navigator", "vendor" ] JD.string


vendorSub : Pipe Window String a
vendorSub =
    requiredAtPipe [ "navigator", "vendorSub" ] JD.string


virtualKeyboard : Pipe Window VirtualKeyboard a
virtualKeyboard =
    requiredAtPipe [ "navigator", "virtualKeyboard" ]
        (JD.map2 VirtualKeyboard
            (JD.field "boundingRect" domRect)
            (JD.field "overlaysContent" JD.bool)
        )


type alias VirtualKeyboard =
    { boundingRect : DOMRect
    , overlaysContent : Bool
    }


type alias DOMRect =
    { bottom : Float
    , height : Float
    , left : Float
    , right : Float
    , top : Float
    , width : Float
    , x : Float
    , y : Float
    }


domRect : JD.Decoder DOMRect
domRect =
    JD.map8 DOMRect
        (JD.field "bottom" JD.float)
        (JD.field "height" JD.float)
        (JD.field "left" JD.float)
        (JD.field "right" JD.float)
        (JD.field "top" JD.float)
        (JD.field "width" JD.float)
        (JD.field "x" JD.float)
        (JD.field "y" JD.float)


devicePixelRatio : Pipe Window Float a
devicePixelRatio =
    requiredPipe "devicePixelRatio" JD.float


localStorage : Pipe Window (Dict String String) a
localStorage =
    requiredPipe "localStorage" (JD.dict JD.string)


locationbar : Pipe Window Bool a
locationbar =
    requiredAtPipe [ "locationbar", "visible" ] JD.bool


menubar : Pipe Window Bool a
menubar =
    requiredAtPipe [ "menubar", "visible" ] JD.bool


scrollbars : Pipe Window Bool a
scrollbars =
    requiredAtPipe [ "scrollbars", "visible" ] JD.bool


styleMedia : Pipe Window String a
styleMedia =
    requiredAtPipe [ "styleMedia", "type" ] JD.string


toolbar : Pipe Window Bool a
toolbar =
    requiredAtPipe [ "toolbar", "visible" ] JD.bool


type alias SpeechSynthesis =
    { paused : Bool
    , pending : Bool
    , speaking : Bool
    }


speechSynthesis : Pipe Window SpeechSynthesis a
speechSynthesis =
    requiredPipe "speechSynthesis"
        (JD.map3 SpeechSynthesis
            (JD.field "paused" JD.bool)
            (JD.field "pending" JD.bool)
            (JD.field "speaking" JD.bool)
        )


performance : Pipe Window Performance a
performance =
    requiredPipe "performance"
        (JD.map4 Performance
            (JD.at [ "eventCounts", "size" ] JD.int)
            (JD.field "memory" memoryInfo)
            (JD.field "timeOrigin" JD.float)
            (JD.field "timing" performanceTiming)
        )


type alias Performance =
    { eventCounts : Int
    , memory : MemoryInfo
    , timeOrigin : Float
    , timing : PerformanceTiming
    }


type alias MemoryInfo =
    { jsHeapSizeLimit : Int
    , totalJSHeapSize : Int
    , usedJSHeapSize : Int
    }


memoryInfo : JD.Decoder MemoryInfo
memoryInfo =
    JD.map3 MemoryInfo
        (JD.field "jsHeapSizeLimit" JD.int)
        (JD.field "totalJSHeapSize" JD.int)
        (JD.field "usedJSHeapSize" JD.int)


type alias PerformanceTiming =
    { connectEnd : Int
    , connectStart : Int
    , domComplete : Int
    , domContentLoadedEventEnd : Int
    , domContentLoadedEventStart : Int
    , domInteractive : Int
    , domLoading : Int
    , domainLookupEnd : Int
    , domainLookupStart : Int
    , fetchStart : Int
    , loadEventEnd : Int
    , loadEventStart : Int
    , navigationStart : Int
    , redirectEnd : Int
    , redirectStart : Int
    , requestStart : Int
    , responseEnd : Int
    , responseStart : Int
    , secureConnectionStart : Int
    , unloadEventEnd : Int
    , unloadEventStart : Int
    }


performanceTiming : JD.Decoder PerformanceTiming
performanceTiming =
    JD.succeed PerformanceTiming
        |> JP.required "connectEnd" JD.int
        |> JP.required "connectStart" JD.int
        |> JP.required "domComplete" JD.int
        |> JP.required "domContentLoadedEventEnd" JD.int
        |> JP.required "domContentLoadedEventStart" JD.int
        |> JP.required "domInteractive" JD.int
        |> JP.required "domLoading" JD.int
        |> JP.required "domainLookupEnd" JD.int
        |> JP.required "domainLookupStart" JD.int
        |> JP.required "fetchStart" JD.int
        |> JP.required "loadEventEnd" JD.int
        |> JP.required "loadEventStart" JD.int
        |> JP.required "navigationStart" JD.int
        |> JP.required "redirectEnd" JD.int
        |> JP.required "redirectStart" JD.int
        |> JP.required "requestStart" JD.int
        |> JP.required "responseEnd" JD.int
        |> JP.required "responseStart" JD.int
        |> JP.required "secureConnectionStart" JD.int
        |> JP.required "unloadEventEnd" JD.int
        |> JP.required "unloadEventStart" JD.int
