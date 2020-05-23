module Main exposing (..)

import Browser
import Random
import Html exposing (Html, Attribute, button, div, h1, img, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

-- MAIN

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

-- MODEL

type alias Model =
  { imageUrl: String
  , question : String
  , answer : Answer

  }

init : () -> (Model, Cmd Msg)
init _ =
  ( Model "/assets/before.jpg" "" None
  , Cmd.none
  )

type Answer
  = None
  | Yes
  | No
  | Nothing
  | Neither
  | Someday
  | Again

-- UPDATE

type Msg
  = Change String
  | Ready
  | Clicked
  | NewAnswer Answer

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Change newQuestion ->
      ( { model | question = newQuestion }
      , Cmd.none
      )

    Ready ->
      ( Model "/assets/before.jpg" "" None
      , Cmd.none
      )

    Clicked ->
      ( model
      , Random.generate NewAnswer answerGenerator
      )

    NewAnswer newAnswer ->
      ( Model "/assets/after.jpg" "" newAnswer
      , Cmd.none
      )

answerGenerator : Random.Generator Answer
answerGenerator =
  Random.uniform None
    [ Yes
    , No
    , Nothing
    , Neither
    , Someday
    , Again
    ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ img [ src model.imageUrl, width 650 ] []
    , input [ placeholder "마법의 소라고동님께 질문해보세요", value model.question, onClick Ready, onInput Change ] []
    , button [ onClick Clicked ] [ text "질문하기" ]
    , h1 [] [ text (viewAnswer model.answer) ]
    ]

viewAnswer : Answer -> String
viewAnswer answer =
  case answer of
    None -> ""
    Yes -> "그래."
    No -> "안 돼."
    Nothing -> "아무것도 하지마."
    Neither -> "다 안 돼."
    Someday -> "언젠가는."
    Again -> "다시 한 번 물어봐."

