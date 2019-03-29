{-# LANGUAGE NoImplicitPrelude, OverloadedStrings #-}
import Import
import Model
import Prelude ((!!))

import Control.Monad.Logger (runStderrLoggingT)
import Database.Persist.Postgresql (pgConnStr, withPostgresqlConn, runSqlConn, rawExecute)
import System.Random (randomRIO)

getRandomElem :: [a] -> IO a
getRandomElem xs = fmap (xs !!) $ randomRIO (0, length xs - 1)

insertPark :: MonadIO m => (Text, Maybe Text) -> ReaderT SqlBackend m ()
insertPark (name, address) = do
  (doubleRims, lit, numBaskets, rating, notes) <- liftIO $ getRandomElem courts
  parkId <- insert $ Park name address
  insert_ $ Court doubleRims lit numBaskets rating (Just notes) (Just parkId)

parks :: [(Text, Maybe Text)]
parks =
  [ ( "Meadowbrook"
    , Just "3377 South Layton Lakes Boulevard, Chandler, AZ 85286"
    )
  , ("Centennial", Just "2475 E Markwood Dr, Chandler, AZ 85286")
  ]

courts :: [(Bool, Bool, Int, Int, Text)]
courts =
  [(True, True, 2, 4, ""), (True, True, 2, 3, ""), (False, False, 2, 4, "")]

main :: IO ()
main = do
  settings <- loadYamlSettingsArgs [configSettingsYmlValue] useEnv
  let conn = (pgConnStr $ appDatabaseConf settings)
  runStderrLoggingT . withPostgresqlConn conn $ runSqlConn $ do
    runMigration migrateAll
    mapM_ insertPark parks
