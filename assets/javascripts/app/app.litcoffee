
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

-----------------------------
Signup check
Check for duplicate users
Gets a user check
Adds a cours for a user check
-----------------------------

        user =
          name: "test"
          _id: "test3" 
          password: "testing"
          courses: [
            code: "51a36fe7661b35241f000002"
            permission: 'w'
          ,
            code: "51a36fe7661b35241f000003"
            permission: 'r'
          ]

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

------------------------------
Checking that a user can login
------------------------------

        user1 =
          name: "test"
          _id: "test3" 
          password: "testing1"

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
          name: "file"
          _id: "testFile" 
          path: "/home/app"
          owner: "test3"
          course: "NAC"

        $.post '/api/files', file, (data, status) ->
          log "File Check", "status", status, "data", data
          $.get '/api/files/testFile1', (data, status) ->
            log "Getting a file", "status", status, "data", data
          .fail (error) ->
            log "Getting a file error", error 
        .fail (error) ->
          log "File error", error
     
------------------------------------
Adding a question
Getting a question check
------------------------------------

        question =
          _id: "Q1" 
          owner: "testOwner"
          filePosition: "100"
          file: "File1"

        $.post '/api/questions', question, (data, status) ->
          log "Question Check", "status", status, "data", data
          $.get '/api/questions/Q1', (data, status) ->
            log "Getting a question", "status", status, "data", data
          .fail (error) ->
            log "Getting a question error", error
        .fail (error) ->
          log "Question error", error


------------------------------------
Adding an answer
Getting an answer check
------------------------------------

        answer =
          _id: "A1" 
          owner: "testOwner"
          question: "Q1"
          rank: 5 


        $.post '/api/answers', answer, (data, status) ->
          log "Answer Check", "status", status, "data", data
          $.get '/api/answers/A1', (data, status) ->
            log "Getting an answer", "status", status, "data", data
          .fail (error) ->
            log "Getting an answer error", error
        .fail (error) ->
          log "Answer error", error


---------------------------------------
Adding a comment to a question
Getting a comment from a question check
---------------------------------------

        comment =
          _id: "testcomment1" 
          owner: "testOwnerComment"
          question: "Question?"

        $.post '/api/commentsQ', comment, (data, status) ->
          log "Comment Q Check", "status", status, "data", data
          $.get '/api/commentsQ/testcomment1', (data, status) ->
            log "Getting a comment from a question", "status", status, "data", data
          .fail (error) ->
            log "Getting a comment error from a question", error
        .fail (error) ->
          log "Comment Q error", error


---------------------------------------
Adding a comment to an answer
Getting a comment from an answer check
---------------------------------------

        comment2 =
          _id: "testcomment2" 
          owner: "testOwnerComment"
          answer: "answer"

        $.post '/api/commentsA', comment2, (data, status) ->
          log "Comment A Check", "status", status, "data", data
          $.get '/api/commentsA/testcomment2', (data, status) ->
            log "Getting a comment from an answer", "status", status, "data", data
          .fail (error) ->
            log "Getting a comment from an answer error", error
        .fail (error) ->
          log "Comment A error", error








        
          



