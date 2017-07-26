module Main exposing (..)

import Html exposing (Html)
import Html exposing (Html)
import Html.Attributes as Attrs
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


allRankOptions : List String
allRankOptions =
    ""
        :: List.map toString
            [ VeryGood
            , Good
            , Satisfactory
            , Fair
            , Insufficient
            , ToReject
            ]


type alias Vote =
    Dict Candidate Rank


type alias Votes =
    Dict Voter Vote


type alias Model =
    { candidates : Candidates
    , vote : Votes
    }


initialModel : Model
initialModel =
    Model
        [ "Titi", "Tata", "Tutu" ]
        (Dict.fromList
            [ ( "Abbie", Dict.singleton "Titi" Good )
            , ( "Bob", Dict.singleton "Tata" VeryGood )
            , ( "Cal", Dict.singleton "Titi" ToReject )
            ]
        )


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- View


view : Model -> Html msg
view model =
    Html.div []
        [ Html.table []
            [ viewCandidatesHeader model.candidates
            , viewVotes model
            ]
        ]


viewCandidatesHeader : Candidates -> Html msg
viewCandidatesHeader candidates =
    Html.thead []
        [ Html.tr []
            (List.map viewCandidate ("Candidates:" :: candidates))
        ]


viewCandidate : Candidate -> Html msg
viewCandidate candidate =
    Html.th []
        [ Html.text candidate
        ]


viewVotes : Model -> Html msg
viewVotes model =
    Html.tbody []
        (List.map (viewVoterRow model) (Dict.toList model.vote))


viewVoterRow : Model -> ( Voter, Vote ) -> Html msg
viewVoterRow model ( voter, vote ) =
    Html.tr []
        ((Html.td [] [ Html.text voter ])
            :: viewVoterVotes model.candidates vote
        )


viewVoterVotes : Candidates -> Vote -> List (Html msg)
viewVoterVotes candidates vote =
    List.map (viewVoterVote vote) candidates


viewVoterVote : Vote -> Candidate -> Html msg
viewVoterVote vote candidate =
    let
        v =
            Maybe.withDefault "" (Maybe.map toString (Dict.get candidate vote))
    in
        Html.td []
            [ Html.select []
                (List.map (viewVoteOption v) allRankOptions)
            ]


viewVoteOption : String -> String -> Html msg
viewVoteOption vote rank =
    Html.option
        [ Attrs.selected (vote == rank)
        ]
        [ Html.text rank ]



-- Message


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    ( model, Cmd.none )
