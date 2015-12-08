
function getalltodo(onSuccess, onError)
{
  $.ajax(
    { url: '/todo/all'
    , success: onSuccess
    , error: onError
    , type: 'GET'
    });
}

function posttodo(body, onSuccess, onError)
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

function puttodo(id, body, onSuccess, onError)
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

function deletetodo(id, onSuccess, onError)
{
  $.ajax(
    { url: '/todo/' + encodeURIComponent(id) + ''
    , success: onSuccess
    , error: onError
    , type: 'DELETE'
    });
}
