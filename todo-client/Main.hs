{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

import Control.Monad (void)
import Control.Monad.IO.Class
import Network.HTTP.Client (newManager, defaultManagerSettings)
import Servant.API
import Servant.Client

import Todo as Todo

getTodoAll   :: ClientM [Todo]
postTodo     :: Todo -> ClientM Todo
putTodoId    :: Int -> Todo -> ClientM ()
deleteTodoId :: Int -> ClientM ()

getTodoAll :<|> postTodo :<|> putTodoId :<|> deleteTodoId = client Todo.crud

todoList :: [Todo]
todoList =
    [ Todo 1 "アドベントカレンダーを書く" False
    , Todo 2 "Haskellで仕事する" False
    , Todo 3 "寝る" False
    ]

main :: IO ()
main = do
  manager <- newManager defaultManagerSettings
  let env = mkClientEnv manager $ BaseUrl Http "localhost" 8080 ""
  void . flip runClientM env $ do
    mapM_ postTodo todoList
    putTodoId 1 $ (todoList !! 0) {done = True}
    deleteTodoId 3
    list <- getTodoAll
    liftIO . mapM_ putStrLn $ map title list
