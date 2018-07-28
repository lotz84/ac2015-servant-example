{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

import Control.Concurrent.STM
import Control.Monad.IO.Class
import Data.Aeson
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Lazy as B
import Data.IntMap (IntMap)
import qualified Data.IntMap as IntMap
import GHC.Generics
import Network.HTTP.Media ((//), (/:))
import Servant
import qualified Network.Wai.Handler.Warp as Warp

import Todo as Todo

type API = Get '[HTML] ByteString
         :<|> "static" :> Raw
         :<|> Todo.CRUD

data HTML

instance Accept HTML where
  contentType _ = "text" // "html" /: ("charset", "utf-8")

instance MimeRender HTML ByteString where
  mimeRender _ bs = bs

api :: Proxy API
api = Proxy

server :: ByteString -> TVar (Int, IntMap Todo) -> Server API
server indexHtml db = index
       :<|> serveDirectoryFileServer "todo-server/static"
       :<|> getTodoAll
       :<|> postTodo
       :<|> putTodoId
       :<|> deleteTodoId
  where
    index              = pure indexHtml
    getTodoAll         = liftIO $ IntMap.elems . snd <$> atomically (readTVar db)
    postTodo todo      = liftIO . atomically $ do
                           (maxId, m) <- readTVar db
                           let newId = maxId + 1
                               newTodo = todo {todoId = newId}
                           writeTVar db (newId, IntMap.insert newId newTodo m)
                           pure newTodo
    putTodoId tid todo = liftIO . atomically . modifyTVar db $
                           \(maxId, m) -> (maxId, IntMap.insert tid todo m)
    deleteTodoId tid   = liftIO . atomically . modifyTVar db $
                           \(maxId, m) -> (maxId, IntMap.delete tid m)

main :: IO ()
main = do
  db <- atomically $ newTVar (0, IntMap.empty)
  indexHtml <- B.readFile "todo-server/templates/index.html"
  putStrLn "Listening on port 8080"
  Warp.run 8080 $ serve api (server indexHtml db)