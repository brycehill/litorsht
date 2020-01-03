{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import

getLoginR :: Handler Html
getLoginR = do
  defaultLayout $ do
    setTitle "Login"
    $(widgetFile "login")
