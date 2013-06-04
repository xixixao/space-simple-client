Client
======

Uses jQuery to make simple requests to our Cloud api.

    define ['jquery', './utilities'], ($, {log, note, blame}) ->

      $.put = (url, data, success) ->
        $.ajax {url, data, success}

Code will be executed after document has loaded.

      $ ->

Server check
------------

Verify that proxy is established to our Cloud server.

        note "Server check", $.get '/api/server-check'


Try post with some data.

        note "Server check for POST", $.post '/api/server-check', "data"

Signup check
------------

First we need to sign a user up.

        testUser =
          name: "test"
          _id: "test3" 
          password: "testing"
          topics: [
            code: "212"
            permission: 'w'
          ]

        userAdded = $.post '/api/users', testUser
        note "Signup Check", userAdded

We then check that we can't make a duplicate sign up.

        note "Duplicate Check", userAdded.then ->
          $.post '/api/users', testUser

          # $.post '/api/users/test3', user, (data, status) ->
          #   log "Adding a topic", "status", status, "data", data

Login check
-----------

Checking that a user can login.

        userLoggedIn = userAdded.then ->
          $.post '/api/login', testUser

        note "Log in", userLoggedIn

Checking that a user that's not signed up cannot log in.

        badUser =
          name: "rogue"
          _id: "test3" 
          password: "backstab"

        blame "Invalid user", userAdded.then ->
          $.post '/api/login', badUser

Checking that user must have a correct password.

        forgetfulTestUser = $.extend {}, testUser
        forgetfulTestUser.password = "rubish"

        blame "Invalid password", userAdded.then ->
          $.post '/api/login', forgetfulTestUser

Topics
------

Adding a topic check

        topic =
          name: "NAC"
          _id: "212"

        topicAdded = $.post '/api/topics', topic
        note "Topic addition", topicAdded

Getting a topic check

        note "Getting a topic", topicAdded.then ->
          $.get '/api/topics/212'

---------------------------------
Adding a file
Getting a file check
Adding questions for a file check
---------------------------------

        file =
          name: "file"
          _id: "testFile1" 
          path: "/home/app"
          owner: "test3"
          topic: "212"

        #$.post '/api/files', file, (data, status) ->
        #  log "File Check", "status", status, "data", data

        # $.post '/api/files', file, (data, status) ->
        #   log "File Check", "status", status, "data", data
        #   $.get '/api/files/testFile1', (data, status) ->
        #     log "Getting a file", "status", status, "data", data
        #   .fail (error) ->
        #     log "Getting a file error", error 
        # .fail (error) ->
        #   log "File error", error
     
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








        
          



