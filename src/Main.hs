{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text.IO        as T
import           Text.Karver
import           Control.Applicative ((<$>))
import           Text.JsonBib.Types


main :: IO ()
main = do
  tplStr <- T.readFile tpltF
  bib    <- readBib    bibF
  let htmlStr = renderTemplate bib tplStr
  T.writeFile outF htmlStr
  where
    tpltF = "examples/pubs.html"
    bibF  = "examples/bib.json"
    outF  = "dist/output.html"
