module Main exposing (..)

import Html exposing (Html)
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
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


view : Model -> Html Msg
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


viewVotes : Model -> Html Msg
viewVotes model =
    Html.tbody []
        (List.map (viewVoterRow model) (Dict.toList model.vote))


viewVoterRow : Model -> ( Voter, Vote ) -> Html Msg
viewVoterRow model ( voter, vote ) =
    Html.tr []
        ((Html.td [] [ Html.text voter ])
            :: viewVoterVotes model.candidates voter vote
        )


viewVoterVotes : Candidates -> Voter -> Vote -> List (Html Msg)
viewVoterVotes candidates voter vote =
    List.map (viewVoterVote voter vote) candidates


viewVoterVote : Voter -> Vote -> Candidate -> Html Msg
viewVoterVote voter vote candidate =
    let
        v =
            Maybe.withDefault "" (Maybe.map toString (Dict.get candidate vote))
    in
        Html.td []
            [ Html.select [ Events.onInput (CastVote voter candidate) ]
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
    = CastVote Voter Candidate String


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        CastVote voter candidate rankStr ->
            let
                voterVote =
                    Maybe.withDefault Dict.empty (Dict.get voter model.vote)

                updatedVote =
                    Dict.insert candidate (parseRank rankStr) voterVote

                updatedVotes =
                    Dict.insert voter updatedVote model.vote
            in
                ( { model | vote = updatedVotes }, Cmd.none )


parseRank : String -> Rank
parseRank s =
    case s of
        "VeryGood" ->
            VeryGood

        "Good" ->
            Good

        "Satisfactory" ->
            Satisfactory

        "Fair" ->
            Fair

        "Insufficient" ->
            Insufficient

        "ToReject" ->
            ToReject

        _ ->
            ToReject
