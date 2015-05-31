{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

import           GHC.Generics
import           Data.Aeson.Types    hiding (Value)
import           Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as H
import           Data.Text           (Text)
import qualified Data.Text.IO        as T
import qualified Data.Vector         as V
import           Text.Karver

import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as H
import Data.Text (Text)
import qualified Data.Text.IO as T
import qualified Data.Vector as V


main :: IO ()
main = do
  tplStr <- T.readFile "examples/grocery.html"
  bibStr <- T.readFile "examples/bib.json"
  let htmlStr = renderTemplate templateHashMap' tplStr
  T.writeFile "dist/output.html" htmlStr
