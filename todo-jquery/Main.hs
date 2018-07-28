{-# LANGUAGE OverloadedStrings #-}

import Servant.JS
import Servant.JS.JQuery
import Todo as Todo

main :: IO ()
main = writeJSForAPI Todo.crud jquery "todo-server/static/todo_crud.js"
