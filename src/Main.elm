module Main exposing (..)

import Html


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init =
    ( {}, Cmd.none )


view model =
    Html.text "Hello"


update message model =
    ( model, Cmd.none )
