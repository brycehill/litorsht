{-# LANGUAGE NoImplicitPrelude, OverloadedStrings #-}
import Import
import Model
import Control.Monad.Logger (runStderrLoggingT)
import Database.Persist.Postgresql (pgConnStr, withPostgresqlConn, runSqlConn, rawExecute)

insertPark :: MonadIO m => (Text, Maybe Text) -> ReaderT SqlBackend m ()
insertPark (name, address) = insert_ $ Park name address

parks :: [(Text, Maybe Text)]
parks =
  [ ( "Meadowbrook"
    , Just "3377 South Layton Lakes Boulevard, Chandler, AZ 85286"
    )
  , ("Centennial", Just "2475 E Markwood Dr, Chandler, AZ 85286")
  ]

courts :: []
courts = []

main :: IO ()
main = do
  settings <- loadYamlSettingsArgs [configSettingsYmlValue] useEnv
  let conn = (pgConnStr $ appDatabaseConf settings)
  runStderrLoggingT . withPostgresqlConn conn $ runSqlConn $ do
    runMigration migrateAll
    mapM_ insertPark parks
