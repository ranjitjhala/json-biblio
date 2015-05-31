{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Text.JsonBib.Types ( readBib, bv ) where

import           GHC.Generics
import           Data.Aeson.Types    hiding (Value)
import           Data.Text           (Text)
import           Data.Aeson          (eitherDecode')
import           Text.Karver         (Value)
import qualified Data.HashMap.Strict as H
import           Control.Applicative ((<$>))
import qualified Data.ByteString.Lazy as LB

type BibValue = H.HashMap Text Value

readBib :: FilePath -> IO BibValue
readBib f = do
  b <- eitherDecode' <$> LB.readFile f
  case b of
    Left err -> error err
    Right v  -> return $ bibValue v

bibValue :: Bib -> BibValue
bibValue b = H.fromList [ ("pubs", value $ pubs b)]

value :: (ToJSON a) => a -> Value
value z = case mkValue z of
            Error s   -> error $ "Error converting from JSON:" ++ s
            Success s -> s
  where
    mkValue :: (ToJSON a) => a -> Result Value
    mkValue = fromJSON . toJSON

data Pub = Pub {
    name       :: Text
  , year       :: Int
  , venue      :: Text
  , shortvenue :: Text
  , authors    :: [Text]
  , url        :: Text
  }
  deriving (Eq, Ord, Show, Generic)

data Bib = Bib {
    pubs :: [Pub]
  }
  deriving (Eq, Ord, Show, Generic)

instance FromJSON Pub
instance FromJSON Bib
instance ToJSON   Pub
instance ToJSON   Bib


