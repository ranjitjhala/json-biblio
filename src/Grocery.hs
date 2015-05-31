{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

import           Data.Aeson.Types    hiding (Value)
import           Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as H
import           Data.Text           (Text)
import qualified Data.Text.IO        as T
import qualified Data.Vector         as V
import           GHC.Generics
import           Text.Karver

data Item = Item { name  :: Text
                 , price :: Text }
            deriving Generic

instance ToJSON Item


templateHashMap :: HashMap Text Value
templateHashMap = H.fromList $
  [ ("title", Literal "Grocery List")
  , ("items", List $ V.fromList [ Literal "eggs"
                                , Literal "flour"
                                , Literal "cereal"
                                ])
  ]

templateHashMap' :: HashMap Text Value
templateHashMap' = H.fromList [ ("title", Literal "Grocery List")
                              , ("items", items)
                              ]

items :: Value
items = value [ Item { name = "eggs"   , price = "1.2" }
              , Item { name = "flour"  , price = "2.3" }
              , Item { name = "cereal" , price = "7.1" }
              ]


value :: (ToJSON a) => a -> Value
value z = case mkValue z of
            Error s   -> error $ "Error converting from JSON:" ++ s
            Success s -> s
  where
    mkValue :: (ToJSON a) => a -> Result Value
    mkValue = fromJSON . toJSON

main :: IO ()
main = do
  tplStr <- T.readFile "examples/grocery.html"
  let htmlStr = renderTemplate templateHashMap' tplStr
  T.writeFile "dist/output.html" htmlStr
