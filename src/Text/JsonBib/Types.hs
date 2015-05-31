{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Text.JsonBib.Types where


import           GHC.Generics
import           Data.Aeson.Types    hiding (Value)
import           Data.Text           (Text)
import           Text.Karver         (Value)


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

instance ToJSON Pub
instance ToJSON Bib


value :: (ToJSON a) => a -> Value
value z = case mkValue z of
            Error s   -> error $ "Error converting from JSON:" ++ s
            Success s -> s
  where
    mkValue :: (ToJSON a) => a -> Result Value
    mkValue = fromJSON . toJSON

