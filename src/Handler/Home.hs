{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Database.Persist.Sql (rawSql)

getHomeR :: Handler Html
getHomeR = do
-- TODO asc on park name and then pass in filters/sorts from query params
  parks <- runDB $ rawSql
    "SELECT ??, ?? FROM park LEFT JOIN court ON park.id = court.park_id;"
    []

  defaultLayout $ do
    setTitle "🔥 or 💩- Lit or Sht"
    $(widgetFile "homepage")


