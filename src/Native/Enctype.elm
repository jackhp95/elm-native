module Native.Enctype exposing (application)

import Native.Entry as Entry
import Native.Enctype.SearchParams as SearchParams exposing (SearchParams)
import Native.Internal as Native exposing (Entry)



-- Enctype


application : Native.Node Entry SearchParams
application =
    Entry.concatFormEntries SearchParams.fromEntries
