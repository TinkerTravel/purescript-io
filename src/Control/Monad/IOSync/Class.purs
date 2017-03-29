module Control.Monad.IOSync.Class where

import Control.Monad.Eff.Class (liftEff)
import Control.Monad.IO (IO)
import Control.Monad.IOSync (IOSync)
import Data.Newtype (unwrap, wrap)
import Prelude

class (Monad m) <= MonadIOSync m where
  liftIOSync :: ∀ a. IOSync a -> m a

instance monadIOSyncIOSync :: MonadIOSync IOSync where
  liftIOSync = id

instance monadIOSyncIO :: MonadIOSync IO where
  liftIOSync = wrap <<< liftEff <<< unwrap
