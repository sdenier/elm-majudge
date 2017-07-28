module Main exposing (..)

import Html exposing (Html)
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Dict exposing (Dict)
import Material.Scheme


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


type alias Elector =
    String


type alias Electors =
    List Elector


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
    Dict Elector Rank


type alias Votes =
    Dict Candidate Vote


type alias Model =
    { electors : Electors
    , vote : Votes
    }


initialModel : Model
initialModel =
    Model
        [ "Titi", "Tata", "Tutu", "Toto" ]
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
            [ viewElectorsHeader model.electors
            , viewVotes model
            ]
        , Html.button [ Attrs.class "mdl-button mdl-js-button mdl-button--fab mdl-button--colored" ]
            [ Html.i [ Attrs.class "material-icons" ] [ Html.text "add" ]
            ]
        ]
        |> Material.Scheme.top


viewElectorsHeader : Electors -> Html msg
viewElectorsHeader electors =
    Html.thead []
        [ Html.tr []
            (List.map viewElector ("Electors:" :: electors))
        ]


viewElector : Elector -> Html msg
viewElector candidate =
    Html.th []
        [ Html.text candidate
        ]


viewVotes : Model -> Html Msg
viewVotes model =
    Html.tbody []
        (List.map (viewCandidateVoteDetails model) (Dict.toList model.vote))


viewCandidateVoteDetails : Model -> ( Candidate, Vote ) -> Html Msg
viewCandidateVoteDetails model ( candidate, vote ) =
    Html.tr []
        ((Html.td [] [ Html.text candidate ])
            :: List.map (viewElectorVoteFor candidate vote) model.electors
        )


viewElectorVoteFor : Candidate -> Vote -> Elector -> Html Msg
viewElectorVoteFor candidate vote elector =
    let
        v =
            Maybe.withDefault "" (Maybe.map toString (Dict.get elector vote))
    in
        Html.td []
            [ Html.select [ Events.onInput (CastVote candidate elector) ]
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
    = CastVote Candidate Elector String


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        CastVote candidate elector rankStr ->
            let
                candidateVote =
                    Maybe.withDefault Dict.empty (Dict.get candidate model.vote)

                updatedVote =
                    Dict.insert elector (parseRank rankStr) candidateVote

                updatedVotes =
                    Dict.insert candidate updatedVote model.vote
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
