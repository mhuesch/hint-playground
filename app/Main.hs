module Main where

import MyLib (loadFoo)

main = do
  print =<< loadFoo
