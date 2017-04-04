module Control.Monad.IO
  ( module Control.Monad.IO.Effect
  , IO(..)
  , runIO
  , runIO'
  , launchIO
  ) where

import Control.Alt (class Alt)
import Control.Alternative (class Alternative)
import Control.Monad.Aff (Aff, launchAff)
import Control.Monad.Aff.Class (class MonadAff)
import Control.Monad.Aff.Unsafe (unsafeCoerceAff)
import Control.Monad.Eff.Class (class MonadEff, liftEff)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Eff.Unsafe (unsafeCoerceEff)
import Control.Monad.Error.Class (class MonadError)
import Control.Monad.IO.Effect (INFINITY)
import Control.Monad.IOSync (IOSync)
import Control.Monad.Rec.Class (class MonadRec)
import Control.MonadZero (class MonadZero)
import Control.Plus (class Plus)
import Data.Monoid (class Monoid)
import Data.Newtype (class Newtype, unwrap, wrap)
import Prelude

newtype IO a = IO (Aff (infinity :: INFINITY) a)

runIO :: IO ~> Aff (infinity :: INFINITY)
runIO = unwrap

runIO' :: ∀ eff. IO ~> Aff (infinity :: INFINITY | eff)
runIO' = unsafeCoerceAff <<< unwrap

launchIO :: ∀ a. IO a -> IOSync Unit
launchIO = void <<< liftEff <<< launchAff <<< unwrap

derive instance newtypeIO :: Newtype (IO a) _

derive newtype instance functorIO     :: Functor     IO
derive newtype instance applyIO       :: Apply       IO
derive newtype instance applicativeIO :: Applicative IO
derive newtype instance bindIO        :: Bind        IO
derive newtype instance monadIO       :: Monad       IO

derive newtype instance monadRecIO :: MonadRec IO

derive newtype instance semigroupIO :: (Semigroup a) => Semigroup (IO a)

derive newtype instance monoidIO :: (Monoid a) => Monoid (IO a)

instance monadAffIO :: MonadAff eff IO where
  liftAff = wrap <<< unsafeCoerceAff

instance monadEffIO :: MonadEff eff IO where
  liftEff = wrap <<< liftEff <<< unsafeCoerceEff

derive newtype instance monadErrorIO :: MonadError Error IO

derive newtype instance altIO :: Alt IO

derive newtype instance plusIO :: Plus IO

derive newtype instance alternativeIO :: Alternative IO

derive newtype instance monadZeroIO :: MonadZero IO
