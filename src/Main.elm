module Main exposing (..)

import Html exposing (Html)
import Dict exposing (Dict)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Model


type alias Candidate =
    String


type alias Candidates =
    List Candidate


type alias Voter =
    String


type Rank
    = VeryGood
    | Good
    | Satisfactory
    | Fair
    | Insufficient
    | ToReject


type alias Vote =
    Dict Voter (Dict Candidate Rank)


type alias Model =
    { candidates : Candidates
    , vote : Vote
    }


initialModel : Model
initialModel =
    Model
        [ "Titi", "Tata", "Tutu" ]
        (Dict.fromList
            [ ( "Abbie", Dict.empty )
            , ( "Bob", Dict.empty )
            , ( "Cal", Dict.empty )
            ]
        )


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- View


view : Model -> Html msg
view model =
    Html.div []
        [ Html.div []
            (List.map viewCandidate model.candidates)
        , Html.div []
            (List.map viewVoterVote (Dict.toList model.vote))
        ]


viewCandidate : Candidate -> Html msg
viewCandidate candidate =
    Html.div []
        [ Html.text candidate
        ]


viewVoterVote : ( Voter, Dict a b ) -> Html msg
viewVoterVote ( voter, votes ) =
    Html.div []
        [ Html.span []
            [ Html.text voter
            ]
        ]



-- Message


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    ( model, Cmd.none )
