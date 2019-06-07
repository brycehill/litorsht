{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Admin where

import Import

getAdminR :: Handler Html
getAdminR = do
  defaultLayout $ do
    setTitle "admin"
    $(widgetFile "admin")
  -- eitherUser <- requireAuthPair
  -- case eitherUser of
  --   (Right user) -> defaultLayout $ do
  --     setTitle . toHtml $ userIdent user <> "'s User page"
  --     $(widgetFile "admin")
  --   (Left siteManager) -> defaultLayout $ do
  --     setTitle . toHtml $ userIdent user <> "'s User page"
  --     $(widgetFile "admin")
