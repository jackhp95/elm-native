module Native.Enctype exposing (..)


import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Native
import Native.Entry as Entry
import Native.Form as Form
import Native.Internal as Native exposing (Entry, Form, Window)
import Native.Window as Window
import Native.Enctype.SearchParams as SearchParams exposing (SearchParams)



-- Enctype


application : Native.Node Entry SearchParams
application =
    Entry.concatFormEntries SearchParams.fromEntries


multipart : ()
multipart =
    ()


plainText : String
plainText =
    ""
