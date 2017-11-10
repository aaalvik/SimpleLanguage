module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import SimpleAST exposing (Expr(..))
import SimpleParser exposing (parse)


--import SimpleEvaluator exposing (eval)


type Msg
    = NoOp
    | UpdateString String
    | ParseString


type alias Model =
    { ast : Maybe Expr
    , textInput : Maybe String
    }


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }


model : Model
model =
    { ast = Nothing --Just (Add (Num 2) (Num 3))
    , textInput = Nothing
    }


view : Model -> Html Msg
view model =
    div [ class "page" ]
        [ viewContent model
        ]


viewContent : Model -> Html Msg
viewContent model =
    div [ class "content" ]
        [ div [ class "input-container" ]
            [ input [ class "input", placeholder "Skriv inn uttrykk", onInput UpdateString ] []
            , button [ class "button btn", onClick ParseString ] [ text "Parse" ]
            ]
        , div [ class "result-container" ]
            [ h3 [] [ text "Expr: " ]
            , astToString model.ast
                |> text
            ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        UpdateString inp ->
            { model
                | textInput =
                    if String.isEmpty inp then
                        Nothing
                    else
                        Just inp
            }

        ParseString ->
            { model | ast = parseString model.textInput }


parseString : Maybe String -> Maybe Expr
parseString textInput =
    Maybe.map parse textInput



--<| eval "function foo x y = x + y; foo (3,4);"
-- HELPERS


astToString : Maybe Expr -> String
astToString mAST =
    case mAST of
        Just ast ->
            toString ast

        Nothing ->
            "..."
