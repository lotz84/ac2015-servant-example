
var getTodoAll = function(onSuccess, onError)
{
  $.ajax(
    { url: '/todo/all'
    , success: onSuccess
    , error: onError
    , type: 'GET'
    });
}

var postTodo = function(body, onSuccess, onError)
{
  $.ajax(
    { url: '/todo'
    , success: onSuccess
    , data: JSON.stringify(body)
    , contentType: 'application/json'
    , error: onError
    , type: 'POST'
    });
}

var putTodoById = function(id, body, onSuccess, onError)
{
  $.ajax(
    { url: '/todo/' + encodeURIComponent(id) + ''
    , success: onSuccess
    , data: JSON.stringify(body)
    , contentType: 'application/json'
    , error: onError
    , type: 'PUT'
    });
}

var deleteTodoById = function(id, onSuccess, onError)
{
  $.ajax(
    { url: '/todo/' + encodeURIComponent(id) + ''
    , success: onSuccess
    , error: onError
    , type: 'DELETE'
    });
}
