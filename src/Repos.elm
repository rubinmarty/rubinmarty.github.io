module Repos exposing (getRepos)

import Http exposing (Request, get)
import Json.Decode as JD
import Types exposing (..)


repoDecoder : JD.Decoder Repo
repoDecoder =
    JD.map5 Repo
        (JD.field "name" JD.string)
        (JD.field "description" <| JD.nullable JD.string)
        (JD.field "stargazers_count" <| JD.oneOf [ JD.int, JD.null 0 ])
        (JD.field "language" JD.string)
        (JD.field "has_pages" <| JD.oneOf [ JD.bool, JD.null False ])


repoListDecoder : JD.Decoder (List Repo)
repoListDecoder =
    repoDecoder
        |> JD.maybe
        |> JD.list
        |> JD.map (List.filterMap identity)
        |> JD.map (List.sortBy (\l -> -l.stargazers))


reposRequest : Request (List Repo)
reposRequest =
    get "https://api.github.com/users/rubinmarty/repos" repoListDecoder


getRepos : Cmd Msg
getRepos =
    let
        handle result =
            case result of
                Err err ->
                    NoOp

                Ok data ->
                    Repos data
    in
    Http.send handle reposRequest
