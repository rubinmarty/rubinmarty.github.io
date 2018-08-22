module Types exposing (..)


type alias Model =
    { currentPage : Page
    , repos : List Repo
    }


type Msg
    = NoOp
    | PageTo Page
    | Repos (List Repo)


type Page
    = About
    | Projects
    | Contact


type alias Repo =
    { name : String
    , description : Maybe String
    , stargazers : Int
    , language : String
    , hasPages : Bool
    }
