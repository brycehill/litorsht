{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import

getHomeR :: Handler Html
getHomeR = do
  parks <- runDB $ selectList [] [Asc ParkName]

  defaultLayout $ do
    setTitle "Lit or Sht"
    $(widgetFile "homepage")


