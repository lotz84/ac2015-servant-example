{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

import Control.Concurrent.STM
import Control.Monad.IO.Class
import Data.Aeson
import Data.IntMap (IntMap)
import qualified Data.IntMap as IntMap
import GHC.Generics
import Servant
import Servant.EDE
import qualified Network.Wai.Handler.Warp as Warp

import Todo as Todo

type API = Get '[HTML "index.html"] Object
         :<|> "static" :> Raw
         :<|> Todo.CRUD

-- | 唯一のボイラープレート
api :: Proxy API
api = Proxy

server :: TVar (Int, IntMap Todo) -> Server API
server db = index
       :<|> serveDirectory "todo-server/static"
       :<|> getTodoAll
       :<|> postTodo
       :<|> putTodoId
       :<|> deleteTodoId
  where
    index              = pure mempty
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
  loadTemplates api "todo-server/templates"
  putStrLn "Listening on port 8080"
  Warp.run 8080 $ serve api (server db)
