module View exposing (view)

import Html exposing (Attribute, Html, div, span, text)
import Html.Attributes as Html exposing (class, id)
import Html.Events as Html
import Types exposing (..)


buttonTo : Page -> Attribute Msg
buttonTo page =
    Html.onClick <| PageTo page


aboutButton : Attribute Msg
aboutButton =
    buttonTo About


projectsButton : Attribute Msg
projectsButton =
    buttonTo Projects


contactButton : Attribute Msg
contactButton =
    buttonTo Contact


linkNode : String -> List (Html.Attribute a) -> List (Html a) -> Html a
linkNode link l1 l2 =
    Html.a
        ([ Html.href link, Html.target "_blank" ] ++ l1)
        l2


nameNode : Page -> Html Msg
nameNode page =
    let
        innerNode =
            if page /= About then
                span [ class "fake-link", aboutButton ]

            else
                span [ class "fake-link current" ]
    in
    span [ id "name" ] [ innerNode [ text "Marty Rubin" ] ]


pageNode : Bool -> String -> Attribute Msg -> Html Msg
pageNode isSelected content newPage =
    let
        node =
            if isSelected then
                span [ class "fake-link current" ]

            else
                span [ class "fake-link", newPage ]
    in
    node [ text content ]


aboutMenuNode : Page -> Html Msg
aboutMenuNode page =
    pageNode (page == About) "About" aboutButton


projectsMenuNode : Page -> Html Msg
projectsMenuNode page =
    pageNode (page == Projects) "Projects" projectsButton


contactMenuNode : Page -> Html Msg
contactMenuNode page =
    pageNode (page == Contact) "Contact" contactButton


menuNode : Page -> Html Msg
menuNode page =
    let
        menuSpacer =
            span [ class "spacer" ] [ text "-" ]
    in
    span
        [ id "menu" ]
        [ aboutMenuNode page, menuSpacer, projectsMenuNode page, menuSpacer, contactMenuNode page ]


aboutNode : Html a
aboutNode =
    let
        line string =
            Html.p [] [ text string ]

        content =
            [ line "Welcome to my website."
            , line "My name is Marty, and I'm a junior studying math, computer science, and philosophy at the University of Pennsylvania."
            , line "Check out the 'Projects' tab to see some of the stuff I've made that's up on GitHub."
            , line "To contact me, see the 'Contact' tab."
            ]
    in
    div [ class "inset", id "about" ] content


projectNode : Repo -> Html a
projectNode { name, description, language, hasPages } =
    let
        gitHubLink =
            "https://github.com/rubinmarty/" ++ name

        pagesLink =
            "https://rubinmarty.github.io/" ++ name

        delim =
            text " "

        titleNode =
            linkNode gitHubLink

        title =
            titleNode [] [ text name ]

        languageTag =
            span [ class "language" ] [ text <| "(" ++ language ++ ")" ]

        tryItLink =
            if hasPages then
                linkNode pagesLink [ class "try-it" ] [ text "Try it!" ]

            else
                text ""
    in
    Html.p
        [ class "project" ]
        [ Html.b [] [ title, tryItLink, delim, languageTag ]
        , Html.br [] []
        , text <| Maybe.withDefault "" description
        ]


projectsNode : List Repo -> Html a
projectsNode repos =
    div
        [ id "projects", class "inset" ]
        (List.map projectNode repos)


contactLineNode : String -> String -> Html a
contactLineNode name link =
    Html.p [ class "contact-line" ] [ text <| name ++ ": ", linkNode link [] [ text link ] ]


contactNode : Html a
contactNode =
    div
        [ id "contact", class "inset" ]
        [ contactLineNode "GitHub" "https://github.com/rubinmarty"
        , contactLineNode "LinkedIn" "https://www.linkedin.com/in/martin-rubin/"
        , Html.p [] [ text "Email: rubinmarty {at} gmail" ]
        ]


contentNode : Model -> Html a
contentNode model =
    case model.currentPage of
        About ->
            aboutNode

        Projects ->
            projectsNode model.repos

        Contact ->
            contactNode


footerNode : Html a
footerNode =
    div [ id "footer" ] [ Html.p [] [ text "Last updated 11-23-2018" ] ]


view : Model -> Html Msg
view model =
    div
        [ id "main" ]
        [ div [ id "header" ]
            [ nameNode model.currentPage
            , menuNode model.currentPage
            ]
        , div [ id "content" ]
            [ contentNode model
            , footerNode
            ]
        ]
