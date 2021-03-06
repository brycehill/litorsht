{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Admin where

import Import
import Database.Persist.Sql (rawSql)


parkForm :: Maybe Park -> Form Park
parkForm mPark =
  renderDivs
    $   Park
    <$> areq textField "name"    (parkName <$> mPark)
    <*> aopt textField "image"   (parkImage <$> mPark)
    <*> aopt textField "address" (parkAddress <$> mPark)
    <*> areq textField "city"    (parkCity <$> mPark)
    <*> areq textField "state"   (parkState <$> mPark)
    <*> areq textField "zip"     (parkZip <$> mPark)

courtForm :: ParkId -> Maybe Court -> Form Court
courtForm parkId mCourt =
  renderDivs
    $   Court
    <$> areq (boolField)   "Double Rims"       (courtDouble_rims <$> mCourt)
    <*> areq (boolField)   "Lit"               (courtLit <$> mCourt)
    <*> areq intField "Number of Baskets" (courtNumber_of_baskets <$> mCourt)
    <*> areq intField      "Rating"            (courtRating <$> mCourt)
    <*> aopt textareaField "Notes"             (courtNotes <$> mCourt)
    <*> pure parkId

getAdminR :: Handler Html
getAdminR = do
  ((pResult, pForm), pEnctype) <- runFormPost (parkForm Nothing)
  case pResult of
    FormSuccess park -> do
      parkId  <- runDB $ insert park
      -- Insert a court to prevent exceptions on the home page
      -- TODO: fix those exceptions
      courtId <- runDB $ insert $ Court False False 0 0 (Just "") parkId
      defaultLayout $ do
        setTitle "admin"
        $(widgetFile "admin")

    _ -> defaultLayout $ do
      setTitle "admin"
      $(widgetFile "admin")


postCreateParkR :: Handler Html
postCreateParkR = getAdminR

getAdminParkR :: ParkId -> Handler Html
getAdminParkR parkId = do
  res <- runDB $ rawSql
    "SELECT ??, ?? FROM park LEFT JOIN court ON park.id = court.park_id WHERE park.id=?;"
    [toPersistValue parkId]

  case res of
    [(Entity parkId park, Entity courtId court)] -> do
      ((pResult, pForm), pEnctype) <- runFormPost $ parkForm (Just park)
      ((cResult, cForm), cEnctype) <- runFormPost
        $ courtForm parkId (Just court)
      case pResult of
        FormSuccess park -> do
          runDB $ replace parkId park
          defaultLayout $ do
            setTitle $ toHtml (parkName park)
            $(widgetFile "adminPark")
        _ -> defaultLayout $ do
          setTitle $ toHtml (parkName park)
          $(widgetFile "adminPark")
      case cResult of
        FormSuccess court -> do
          runDB $ replace courtId court
          defaultLayout $ do
            setTitle $ toHtml (parkName park)
            $(widgetFile "adminPark")
        _ -> defaultLayout $ do
          setTitle $ toHtml (parkName park)
          $(widgetFile "adminPark")
    _ -> notFound

postAdminParkR = getAdminParkR
