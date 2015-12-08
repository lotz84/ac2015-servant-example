{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

import Data.Aeson
import GHC.Generics
import qualified Network.Wai.Handler.Warp as Warp
import Servant
import Servant.Mock
import Test.QuickCheck

-- | Todoに関する情報
data Todo = Todo
  { todoId :: Int
  , title  :: String
  , done   :: Bool
  } deriving Generic

instance ToJSON Todo

instance Arbitrary Todo where
  arbitrary = Todo <$> arbitrary <*> arbitrary <*> arbitrary

-- | Todoリスト
todoList :: [Todo]
todoList =
  [ Todo 1 "アドベントカレンダーを書く" True
  , Todo 2 "Haskellで仕事する" False
  , Todo 3 "寝る" False
  ]

-- | Servant によるAPIの型
type API = "todo" :> "all" :> Get '[JSON] [Todo]

-- | 唯一のボイラープレート
api :: Proxy API
api = Proxy

-- | サーバーの実装
server :: Server API
server = pure todoList

main :: IO ()
main = do
  putStrLn "Listening on port 8080"
  -- Warp.run 8080 $ serve api (mock api)
  Warp.run 8080 $ serve api server
