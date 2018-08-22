module Main exposing (..)

import Browser exposing (element)
import Repos
import Types exposing (..)
import View exposing (..)


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( Model About [], Repos.getRepos )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        PageTo page ->
            ( { model | currentPage = page }, Cmd.none )

        Repos repos ->
            ( { model | repos = repos }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
