{-# LANGUAGE LambdaCase, ScopedTypeVariables, TypeApplications #-}
module MyLib
  ( module MyLib
  )
where

import Control.Monad (forM)
import Data.Typeable (Typeable)
import qualified Language.Haskell.Interpreter as Hint

-- |
-- Interpret expressions into values:
--
-- >>> eval @[Int] "[1,2] ++ [3]"
-- [1,2,3]
--
-- Send values from your compiled program to your interpreted program by
-- interpreting a function:
--
-- >>> f <- eval @(Int -> [Int]) "\\x -> [1..x]"
-- >>> f 5
-- [1,2,3,4,5]
eval :: forall t. Typeable t
     => String -> IO t
eval s = do
  res <- Hint.runInterpreter $ do
    Hint.setImports ["Prelude"]
    Hint.interpret s (Hint.as :: t)
  case res of
    Left err -> error ("error: " <> show err)
    Right val -> pure val

loadFoo :: IO [(Hint.ModuleName, [Hint.ModuleElem])]
loadFoo = do
  res <- Hint.runInterpreter $ do
    Hint.loadModules ["Foo.hs"]
    mods <- Hint.getLoadedModules
    forM mods $ \nm -> do
      mes <- Hint.getModuleExports nm
      pure (nm, mes)
  case res of
    Left err -> putStrLn "failed" >> pure []
    Right val -> pure val
