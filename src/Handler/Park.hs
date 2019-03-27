{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Park where

import Import


getParkR :: ParkId -> Handler Html
getParkR parkId = do
  park <- runDB $ get404 parkId

  defaultLayout $ do
    setTitle $ toHtml (parkName park)
    $(widgetFile "park")
