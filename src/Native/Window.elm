module Native.Window exposing (..)

import Dict exposing (Dict)
import Json.Decode as JD
import Json.Decode.Pipeline as JP
import Maybe.Extra
import Native.Internal exposing (..)
import Url exposing (Url)



-- Window


window : Data Window a -> Node Window a
window (Data dec) =
    dec
        |> JD.at [ "ownerDocument", "defaultView" ]
        |> internalDecodeEntry
        |> Node


type alias FlagArg =
    { self : { self : { self : { self : JD.Value } } } }


fromFlag : FlagArg -> Persist
fromFlag flag =
    Persist flag.self.self.self.self



-- Window Hacks


location : Pipe Window Url a
location (Data dec) =
    dec
        |> JP.requiredAt [ "location", "href" ] (JD.andThen (Url.fromString >> Maybe.Extra.unwrap (JD.fail "") JD.succeed) JD.string)
        |> Data


type alias NetworkInformation =
    { downlink : Float
    , effectiveType : String
    , rtt : Float
    , saveData : Bool
    }


networkInformation : Pipe Window NetworkInformation a
networkInformation (Data dec) =
    dec
        |> (JD.succeed NetworkInformation
                |> JP.required "downlink" JD.float
                |> JP.required "effectiveType" JD.string
                |> JP.required "rtt" JD.float
                |> JP.required "saveData" JD.bool
                |> JP.requiredAt [ "navigator", "connection" ]
           )
        |> Data


deviceMemory : Pipe Window Int a
deviceMemory (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "deviceMemory" ] JD.int
        |> Data


doNotTrack : Pipe Window (Maybe Bool) a
doNotTrack (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "doNotTrack" ]
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
        |> Data


hardwareConcurrency : Pipe Window Int a
hardwareConcurrency (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "hardwareConcurrency" ] JD.int
        |> Data


language : Pipe Window String a
language (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "language" ] JD.string
        |> Data


languages : Pipe Window (List String) a
languages (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "languages" ] (JD.list JD.string)
        |> Data


maxTouchPoints : Pipe Window Int a
maxTouchPoints (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "maxTouchPoints" ] JD.int
        |> Data


onLine : Pipe Window Bool a
onLine (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "onLine" ] JD.bool
        |> Data


pdfViewerEnabled : Pipe Window Bool a
pdfViewerEnabled (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "pdfViewerEnabled" ] JD.bool
        |> Data


platform : Pipe Window String a
platform (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "platform" ] JD.string
        |> Data


hasBeenActive : Pipe Window Bool a
hasBeenActive (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "userActivation", "hasBeenActive" ] JD.bool
        |> Data


isActive : Pipe Window Bool a
isActive (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "userActivation", "isActive" ] JD.bool
        |> Data


userAgent : Pipe Window String a
userAgent (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "userAgent" ] JD.string
        |> Data


type alias UserAgentData =
    { brands : List { brand : String, version : String }
    , mobile : Bool
    , platform : String
    }


userAgentData : Pipe Window UserAgentData a
userAgentData (Data dec) =
    dec
        |> (JD.map3 UserAgentData
                (JD.field "brands" (JD.list (JD.map2 (\b v -> { brand = b, version = v }) (JD.field "brand" JD.string) (JD.field "version" JD.string))))
                (JD.field "mobile" JD.bool)
                (JD.field "platform" JD.string)
                |> JP.requiredAt [ "navigator", "userAgentData" ]
           )
        |> Data


vendor : Pipe Window String a
vendor (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "vendor" ] JD.string
        |> Data


vendorSub : Pipe Window String a
vendorSub (Data dec) =
    dec
        |> JP.requiredAt [ "navigator", "vendorSub" ] JD.string
        |> Data


virtualKeyboard : Pipe Window VirtualKeyboard a
virtualKeyboard (Data dec) =
    dec
        |> (JD.map2 VirtualKeyboard
                (JD.field "boundingRect" domRect)
                (JD.field "overlaysContent" JD.bool)
                |> JP.requiredAt [ "navigator", "virtualKeyboard" ]
           )
        |> Data


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
devicePixelRatio (Data dec) =
    dec
        |> JP.required "devicePixelRatio" JD.float
        |> Data


localStorage : Pipe Window (Dict String String) a
localStorage =
    required "localStorage" (dict string)


locationbar : Pipe Window Bool a
locationbar (Data dec) =
    dec
        |> JP.requiredAt [ "locationbar", "visible" ] JD.bool
        |> Data


menubar : Pipe Window Bool a
menubar (Data dec) =
    dec
        |> JP.requiredAt [ "menubar", "visible" ] JD.bool
        |> Data


scrollbars : Pipe Window Bool a
scrollbars (Data dec) =
    dec
        |> JP.requiredAt [ "scrollbars", "visible" ] JD.bool
        |> Data


styleMedia : Pipe Window String a
styleMedia (Data dec) =
    dec
        |> JP.requiredAt [ "styleMedia", "type" ] JD.string
        |> Data


toolbar : Pipe Window Bool a
toolbar (Data dec) =
    dec
        |> JP.requiredAt [ "toolbar", "visible" ] JD.bool
        |> Data


type alias SpeechSynthesis =
    { paused : Bool
    , pending : Bool
    , speaking : Bool
    }


speechSynthesis : Pipe Window SpeechSynthesis a
speechSynthesis (Data dec) =
    dec
        |> (JD.map3 SpeechSynthesis
                (JD.field "paused" JD.bool)
                (JD.field "pending" JD.bool)
                (JD.field "speaking" JD.bool)
                |> JP.required "speechSynthesis"
           )
        |> Data


performance : Pipe Window Performance a
performance (Data dec) =
    dec
        |> (JD.map4 Performance
                (JD.at [ "eventCounts", "size" ] JD.int)
                (JD.field "memory" memoryInfo)
                (JD.field "timeOrigin" JD.float)
                (JD.field "timing" performanceTiming)
                |> JP.required "performance"
           )
        |> Data


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
