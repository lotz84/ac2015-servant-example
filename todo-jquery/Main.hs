import Servant.JQuery
import Todo as Todo

main :: IO ()
main = writeFile "todo-server/static/todo_crud.js" $ jsForAPI Todo.crud
