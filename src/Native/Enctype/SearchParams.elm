module Native.Enctype.SearchParams exposing
    ( SearchParams
    , FormElement, toSearchParams, inputToSearchParams
    , fromEntries, fromUrl, encodeApplication, toString
    , listToTuple
    )

import Maybe.Extra
import Native.Entry as Entry
import Native.Internal as Native exposing (Entry)
import Url exposing (Url)


type alias SearchParams =
    List ( String, String )


type alias FormElement =
    { name : String
    , value : String
    , type_ : String
    , textContent : String
    , tagName : String
    , checked : Maybe Bool
    , multiple : Maybe Bool
    , isActiveElement : Bool
    , disabled : Bool
    , files : List String
    , selectedOptions : List String
    }


toSearchParams : FormElement -> SearchParams
toSearchParams el =
    if el.disabled then
        []

    else
        case el.tagName of
            "SELECT" ->
                if Maybe.withDefault False el.multiple then
                    List.map (Tuple.pair el.name) el.selectedOptions

                else
                    [ ( el.name, el.value ) ]

            "TEXTAREA" ->
                [ ( el.name, el.value ) ]

            "BUTTON" ->
                if (el.type_ == "submit") && el.isActiveElement && (not << String.isEmpty) el.name then
                    [ ( el.name, el.value ) ]

                else
                    []

            "INPUT" ->
                inputToSearchParams el

            _ ->
                []


inputToSearchParams : FormElement -> SearchParams
inputToSearchParams el =
    if List.any ((==) el.type_) [ "radio", "checkbox" ] then
        if Maybe.withDefault False el.checked then
            if String.isEmpty el.value then
                [ ( el.name, "on" ) ]

            else
                [ ( el.name, el.value ) ]

        else
            []

    else if List.member el.type_ [ "reset", "button", "submit" ] then
        []

    else if el.type_ == "file" && Maybe.withDefault False el.multiple then
        if List.isEmpty el.files then
            [ ( el.name, el.value ) ]

        else
            List.map (Tuple.pair el.name) el.files

    else
        [ ( el.name, el.value ) ]


fromEntries : Native.Data Entry SearchParams
fromEntries =
    Native.succeed FormElement
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
        |> Native.map toSearchParams


encodeApplication : SearchParams -> String
encodeApplication =
    List.map (\( name, value ) -> String.join "\n    =" [ name, value ]) >> String.join "\n& "


listToTuple : List String -> Maybe ( String, String )
listToTuple list =
    case list of
        [] ->
            Nothing

        k :: [] ->
            Just ( k, "" )

        k :: v :: _ ->
            Just ( k, v )


fromUrl : Url -> SearchParams
fromUrl { query } =
    Maybe.Extra.unwrap [] (String.split "&" >> List.filterMap (String.split "=" >> listToTuple)) query


toString : SearchParams -> String
toString =
    List.map (\( k, v ) -> k ++ "=" ++ v) >> String.join "&"
