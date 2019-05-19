{-# LANGUAGE NoImplicitPrelude, OverloadedStrings #-}
import Import
import Model
import Prelude ((!!))

import Control.Monad.Logger (runStderrLoggingT)
import Database.Persist.Postgresql (pgConnStr, withPostgresqlConn, runSqlConn, rawExecute)
import System.Random (randomRIO)

-- TODO: First delete data
--
--
getRandomElem :: [a] -> IO a
getRandomElem xs = fmap (xs !!) $ randomRIO (0, length xs - 1)

type ParkSeed = (Text, Maybe Text, Maybe Text, Text, Text, Text)

insertPark :: MonadIO m => ParkSeed -> ReaderT SqlBackend m ()
insertPark (name, image, address, city, state, zip) = do
  (doubleRims, lit, numBaskets, rating, notes) <- liftIO $ getRandomElem courts
  parkId <- insert $ Park name image address city state zip
  insert_ $ Court doubleRims lit numBaskets rating (Just notes) (parkId)

parks :: [ParkSeed]
parks =
  [ ( "Meadowbrook"
    , Nothing
    , Just "3377 South Layton Lakes Boulevard"
    , "Chandler"
    , "AZ"
    , "85286"
    )
  , ( "Centennial"
    , Nothing
    , Just "2475 E Markwood Dr"
    , "Chandler"
    , "AZ"
    , "85286"
    )
  ]


  -- double_rims Bool
  -- lit Bool
  -- number_of_baskets Int
  -- rating Int
  -- notes Text
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
