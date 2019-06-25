module Main where

import Prelude
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1, EffectFn1)
import Spork.Html (Html)
import Spork.Html as H
import Spork.PureApp (PureApp)
import Spork.PureApp as PureApp

type Model
  = Int

data Action
  = Inc
  | Dec

update ∷ Model → Action → Model
update i = case _ of
  Inc → i + 1
  Dec → i - 1

render ∷ Model → Html Action
render i =
  H.div []
    [ H.button
        [ H.onClick (H.always_ Inc) ]
        [ H.text "+" ]
    , H.button
        [ H.onClick (H.always_ Dec) ]
        [ H.text "-" ]
    , H.span []
        [ H.text (show i)
        ]
    ]

type FFIInterface
  = { inc :: Effect Unit
    , dec :: Effect Unit
    , run :: Effect Unit
    }

pureApp ∷ PureApp Model Action
pureApp = { update, render, init: 0 }

mkSporkApp :: EffectFn1 String FFIInterface
mkSporkApp =
  mkEffectFn1 \selector -> do
    app <- PureApp.makeWithSelector pureApp selector
    let
      ffi =
        { inc: app.push Inc
        , dec: app.push Dec
        , run: app.run
        }
    pure ffi
