module Spago.Turtle
  ( echo
  , echoStr
  , die
  , hush
  , withDirectory
  ) where


import           Control.Exception (Exception, onException, throwIO)
import           Data.Text         (Text)
import qualified Data.Text         as Text
import qualified Turtle            as Turtle hiding (die, echo)


-- | Generic Error that we throw on program exit.
--   We have it so that errors are displayed nicely to the user
--   (the default Turtle.die is not nice)
newtype SpagoError = SpagoError { _unError :: Text }
instance Exception SpagoError
instance Show SpagoError where
  show (SpagoError err) = Text.unpack err


echo :: Text -> IO ()
echo = Turtle.printf (Turtle.s Turtle.% "\n")

echoStr :: String -> IO ()
echoStr = echo . Text.pack

die :: Text -> IO a
die reason = throwIO $ SpagoError reason

-- | Suppress the 'Left' value of an 'Either'
hush :: Either a b -> Maybe b
hush = either (const Nothing) Just

-- | Manage a directory tree as a resource, deleting it if we except during the @action@
--   NOTE: you should make sure the directory doesn't exist before calling this.
withDirectory :: Turtle.FilePath -> IO a -> IO a
withDirectory dir action = (Turtle.mktree dir >> action) `onException` (Turtle.rmtree dir)
