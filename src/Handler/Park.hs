{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Park where

import Import

getParkR :: Text -> Handler Html
getParkR id = defaultLayout $ do
  -- boo <- "boo"
  setTitle "Park's Page"
  $(widgetFile "park")
