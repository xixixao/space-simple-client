
Uses jQuery to make simple requests to our Cloud api.

    define ['jquery', './utilities'], ($, {log}) ->

      $.put = (url, data, success) ->
        $.ajax {url, data, success}

Code will be executed after document has loaded.

      $ ->

Verify that proxy is established to our Cloud server.

        $.get '/api/server-check', (data, status) ->
          log "Server check", "status", status, "data", data
        .fail (error) ->
          log "Server check", "error", error

Try post with some data.

------

        $.post '/api/server-check', "data", (data, status) ->
          log "Server check for POST", "status", status, "data", data

        user =
          name: "test"
          username: "test3" 
          password: "testing"
          courses: ["51a36fe7661b35241f000002"]

------  

        $.post '/api/users', user, (data, status) ->
          log "Signup Check", "status", status, "data", data
          # $.post '/api/users', user, (data, status) ->
          #   log "Duplicate Check", "status", status, "data", data
          $.get '/api/users/test3', (data, status) ->
            log "Getting a user", "status", status, "data", data

          $.post '/api/users/test3', user, (data, status) ->
            log "Adding a course", "status", status, "data", data
        .fail (error) ->
          log "Signup", "error", error

        
        user1 =
          name: "test"
          username: "test3" 
          password: "testing1"

------

        $.post '/api/login', user1, (data, status) ->
          log "Login", "status", status, "data", data
        .fail (error) ->
          log "Error login", "error", error

------

        course =
          name: "NAC"
          code: "212"

------  

        $.post '/api/courses', course, (data, status) ->
          log "Signup Course Check", "status", status, "data", data
          # $.post '/api/users', user, (data, status) ->
          #   log "Duplicate Check", "status", status, "data", data
          $.get '/api/courses/212', (data, status) ->
            log "Getting a course", "status", status, "data", data
           .fail (error) ->
            log "Error getting a course", "error", error
        .fail (error) ->
          log "Error signup course", "error", error


------

        
          



