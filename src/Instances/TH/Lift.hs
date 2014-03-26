{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE TemplateHaskell #-}
module Instances.TH.Lift 
  ( -- | This module provides orphan instances for the 'Language.Haskell.TH.Syntax.Lift' class from template-haskell. Following is a list of the provided instances.
    -- 
    -- Lift instances are useful to precompute values at compile time using template haskell. For example, if you write the following code,
    -- you can make sure that @3 * 10@ is really computed at compile time:
    --
    -- > {-# LANGUAGE TemplateHaskell #-}
    -- >
    -- > import Language.Haskell.TH.Syntax
    -- >
    -- > expensiveComputation :: Word32
    -- > expensiveComputation = $(lift $ 3 * 10) -- This will computed at compile time
    --
    -- This uses the Lift instance for Word32.

    -- * Base
    -- |  * 'Word8', 'Word16', 'Word32', 'Word64'
    --
    --    * 'Int8', 'Int16', 'Int32', 'Int64'

    -- * Containers (both strict/lazy)
    -- |  * 'Data.IntMap.IntMap'
    -- 
    --    * 'Data.IntSet.IntSet'
    --    
    --    * 'Data.Map.Map'
    -- 
    --    * 'Data.Set.Set'
    --
    --    * 'Data.Tree.Tree'
    --
    --    * 'Data.Sequence.Seq'

    -- * ByteString (both strict/lazy)
    -- |  * 'Data.ByteString'
    
    -- * Text (both strict/lazy)
    -- |  * 'Data.Text'
  ) where

import Language.Haskell.TH
import Language.Haskell.TH.Lift

import qualified Data.Foldable as F

-- Base
import Data.Int
import Data.Word

-- Containers
import qualified Data.IntMap as IntMap
import qualified Data.IntSet as IntSet
import qualified Data.Map as Map
import qualified Data.Sequence as Sequence
import qualified Data.Set as Set
import qualified Data.Tree as Tree

-- Text
import qualified Data.Text as Text
import qualified Data.Text.Lazy as Text.Lazy

-- ByteString
import qualified Data.ByteString as ByteString
import qualified Data.ByteString.Lazy as ByteString.Lazy
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Base
instance Lift Word8 where
  lift x = [| fromInteger $(lift $ toInteger x) :: Word8 |]

instance Lift Word16 where
  lift x = [| fromInteger $(lift $ toInteger x) :: Word16 |]

instance Lift Word32 where
  lift x = [| fromInteger $(lift $ toInteger x) :: Word32 |]

instance Lift Word64 where
  lift x = [| fromInteger $(lift $ toInteger x) :: Word64 |]

instance Lift Int8 where
  lift x = [| fromInteger $(lift $ toInteger x) :: Int8 |]

instance Lift Int16 where
  lift x = [| fromInteger $(lift $ toInteger x) :: Int16 |]

instance Lift Int32 where
  lift x = [| fromInteger $(lift $ toInteger x) :: Int32 |]

instance Lift Int64 where
  lift x = [| fromInteger $(lift $ toInteger x) :: Int64 |]

instance Lift Float where
  lift x = [| $(litE $ rationalL $ toRational x) :: Float |]

instance Lift Double where
  lift x = [| $(litE $ rationalL $ toRational x) :: Double |]

--------------------------------------------------------------------------------
-- Containers
instance Lift v => Lift (IntMap.IntMap v) where
  lift m = [| IntMap.fromList $(lift $ IntMap.toList m) |]

instance Lift IntSet.IntSet where
  lift s = [| IntSet.fromList $(lift $ IntSet.toList s) |] 

instance (Lift k, Lift v) => Lift (Map.Map k v) where
  lift m = [| Map.fromList $(lift $ Map.toList m) |]

instance Lift a => Lift (Sequence.Seq a) where
  lift s = [| Sequence.fromList $(lift $ F.toList s) |]

instance Lift a => Lift (Set.Set a) where
  lift s = [| Set.fromList $(lift $ Set.toList s) |]

deriveLift ''Tree.Tree

--------------------------------------------------------------------------------
-- Text
instance Lift Text.Text where
  lift t = [| Text.pack $(lift $ Text.unpack t) |]

instance Lift Text.Lazy.Text where
  lift t = [| Text.Lazy.pack $(lift $ Text.Lazy.unpack t) |]

--------------------------------------------------------------------------------
-- ByteString
instance Lift ByteString.ByteString where
  lift b = [| ByteString.pack $(lift $ ByteString.unpack b) |]

instance Lift ByteString.Lazy.ByteString where
  lift b = [| ByteString.Lazy.pack $(lift $ ByteString.Lazy.unpack b) |]