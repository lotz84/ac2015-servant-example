{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

import Control.Monad (void)
import Control.Monad.Trans.Either
import Control.Monad.IO.Class
import Servant.API
import Servant.Client
import Todo as Todo

getTodoAll   :: EitherT ServantError IO [Todo]
postTodo     :: Todo -> EitherT ServantError IO Todo
putTodoId    :: Int -> Todo -> EitherT ServantError IO ()
deleteTodoId :: Int -> EitherT ServantError IO ()

getTodoAll :<|> postTodo :<|> putTodoId :<|> deleteTodoId =
  client Todo.crud $ BaseUrl Http "localhost" 8080

todoList :: [Todo]
todoList =
    [ Todo 1 "アドベントカレンダーを書く" False
    , Todo 2 "Haskellで仕事する" False
    , Todo 3 "寝る" False
    ]

main :: IO ()
main = void . runEitherT $ do
  mapM_ postTodo todoList
  putTodoId 1 $ (todoList !! 0) {done = True}
  deleteTodoId 3
  list <- getTodoAll
  liftIO . mapM_ putStrLn $ map title list

