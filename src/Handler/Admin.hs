{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Admin where

import Import


parkForm :: Form Park
parkForm =
  renderDivs
    $   Park
    <$> areq textField "name"    Nothing
    <*> aopt textField "image"   Nothing
    <*> aopt textField "address" Nothing
    <*> areq textField "city"    Nothing
    <*> areq textField "state"   Nothing
    <*> areq textField "zip"     Nothing

courtForm :: ParkId -> Form Court
courtForm parkId =
  renderDivs
    $   Court
    <$> areq (boolField)   "Double Rims"       Nothing
    <*> areq (boolField)   "Lit"               Nothing
    <*> areq intField      "Number of Baskets" Nothing
    <*> areq intField      "Rating"            Nothing
    <*> aopt textareaField "Notes"             Nothing
    <*> pure parkId

getAdminR :: Handler Html
getAdminR = do
  ((pResult, pForm), pEnctype) <- runFormPost parkForm
  case pResult of
    FormSuccess park -> do
      parkId  <- runDB $ insert park
      courtId <- runDB $ insert $ Court False False 0 0 (Just "") parkId
      defaultLayout $ do
        setTitle "admin"
        $(widgetFile "admin")

    _ -> defaultLayout $ do
      setTitle "admin"
      $(widgetFile "admin")


postCreateParkR :: Handler Html
postCreateParkR = getAdminR

