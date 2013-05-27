
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

------------
Server check
------------

        $.post '/api/server-check', "data", (data, status) ->
          log "Server check for POST", "status", status, "data", data

        user =
          name: "test"
          _id: "test3" 
          password: "testing"
          courses: ["51a36fe7661b35241f000002","51a36fe7661b35241f000003"]


-----------------------------
Signup check
Check for duplicate users
Gets a user check
Adds a cours for a user check
-----------------------------

        $.post '/api/users', user, (data, status) ->
          log "Signup Check", "status", status, "data", data
          $.post '/api/users', user, (data, status) ->
            log "Duplicate Check", "status", status, "data", data
          $.get '/api/users/test3', (data, status) ->
            log "Getting a user", "status", status, "data", data

          $.post '/api/users/test3', user, (data, status) ->
            log "Adding a course", "status", status, "data", data
        .fail (error) ->
          log "Signup", "error", error

        
        user1 =
          name: "test"
          _id: "test3" 
          password: "testing1"

------------------------------
Checking that a user can login
------------------------------

        $.post '/api/login', user1, (data, status) ->
          log "Login", "status", status, "data", data
        .fail (error) ->
          log "Error login", "error", error

----------------------
Adding a course check
Getting a course check
----------------------

        course =
          name: "NAC"
          _id: "212"

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

---------------------------------
Adding a file
Getting a file check
Adding questions for a file check
---------------------------------

        file =
          name: "testFile"
          _id: "testFile1" 
          path: "/home/app"
          owner: "testOwer"

        $.post '/api/files', file, (data, status) ->
          log "File Check", "status", status, "data", data
        .fail (error) ->
          log "File error", error

------------------------------------
Adding a question
Getting a question check
Adding a feed to the questions check
------------------------------------

        question =
          _id: "testQ1" 
          owner: "testOwner"
          filePosition: "100"


        $.post '/api/questions', question, (data, status) ->
          log "Question Check", "status", status, "data", data
        .fail (error) ->
          log "question error", error

--------------------
Adding a feed
Getting a feed check
--------------------

        feed =
          _id: "testFeed1" 
          owner: "testOwner"

        $.post '/api/feeds', feed, (data, status) ->
          log "Feed Check", "status", status, "data", data
        .fail (error) ->
          log "Feed error", error









        
          



