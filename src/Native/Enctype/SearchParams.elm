module Native.Enctype.SearchParams exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Native
import Native.Entry as Entry
import Native.Form as Form
import Native.Internal as Native exposing (Entry, Form, Window)
import Native.Window as Window
import Url exposing (Url)
import Maybe.Extra

type alias SearchParams =
    List ( String, String )


encodeApplication : SearchParams -> String
encodeApplication =
    List.map (\( name, value ) -> String.join "\n    =" [ name, value ]) >> String.join "\n& "


fromEntries : Native.Data Entry SearchParams
fromEntries =
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
