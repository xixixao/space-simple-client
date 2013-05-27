
Uses jQuery to make simple requests to our Cloud api.

    define ['jquery', './utilities'], ($, {log}) ->

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
          login: "test3" 
          password: "testing"

------  

        $.post '/api/users', user, (data, status) ->
          log "Signup Check", "status", status, "data", data
          # $.post '/api/users', user, (data, status) ->
          #   log "Duplicate Check", "status", status, "data", data
          $.get '/api/users/test3', (data, status) ->
            log "Getting a user", "status", status, "data", data
           .fail (error) ->
            log "Error getting a user", "error", error
        .fail (error) ->
          log "Signup", "error", error

        
        user1 =
          name: "test"
          login: "test3" 
          password: "testing1"

------

        $.post '/api/login', user1, (data, status) ->
          log "Login", "status", status, "data", data
        .fail (error) ->
          log "Error login", "error", error



