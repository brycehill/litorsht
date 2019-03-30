{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Park where

import Import
import Database.Persist.Sql (rawSql)


getParkR :: ParkId -> Handler Html
getParkR parkId = do
  -- TODO: Esqueleto?
  res <- runDB $ rawSql
    "SELECT ??, ?? FROM park LEFT JOIN court ON park.id = court.park_id WHERE park.id=?;"
    [toPersistValue parkId]

  defaultLayout $ do
    case res of
      [(Entity _ park, Entity _ court)] -> do
        setTitle $ toHtml (parkName park)
        $(widgetFile "park")
      _ -> notFound

