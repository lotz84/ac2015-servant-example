{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Todo (
  Todo(..)
, CRUD
, crud
) where

import Data.Aeson
import Data.Proxy
import GHC.Generics
import Servant.API
import qualified Data.Text as Text

-- | Todoに関する情報
data Todo = Todo
  { todoId :: Int
  , title  :: String
  , done   :: Bool
  } deriving Generic

instance FromJSON Todo
instance ToJSON Todo

instance FromFormUrlEncoded Todo where
  fromFormUrlEncoded inputs = Todo <$> lkp "todoId" <*> lkp "title" <*> lkp "done"
    where
      lkp l = case lookup l inputs of
                Nothing -> Left $ "label " ++ Text.unpack l ++ " not found"
                Just v  -> Right $ read (Text.unpack v)

type CRUD =    "todo" :> "all" :> Get '[JSON] [Todo]
          :<|> "todo" :> ReqBody '[JSON, FormUrlEncoded] Todo :> Post '[JSON] Todo
          :<|> "todo" :> Capture "id" Int :> ReqBody '[JSON, FormUrlEncoded] Todo :> Put '[JSON] ()
          :<|> "todo" :> Capture "id" Int :> Delete '[JSON] ()

crud :: Proxy CRUD
crud = Proxy
