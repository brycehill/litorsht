{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Profile where

import Import

-- getProfileR :: Handler Html
-- getProfileR = do
--   eitherUser <- requireAuthPair
--   case eitherUser of
--     (Left user) -> defaultLayout $ do
--       setTitle . toHtml $ userIdent user <> "'s User page"
--       $(widgetFile "profile")
--     (Right siteManager) -> defaultLayout $ do
--       setTitle . toHtml $ manUserName siteManager <> "'s User page"
--       $(widgetFile "profile")
