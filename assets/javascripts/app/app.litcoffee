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

API Checking
============

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
          email: "testUser@test.com"
          facebook: "test@facebook.com"

        userAdded = $.post '/api/users', testUser
        note "Signup Check", userAdded

Getting user

        #note "Getting a user", userAdded.then ->
        #  $.get '/api/users/test3'

We then check that we cant make a duplicate sign up.

        #note "Duplicate Check", userAdded.then ->
        #  $.post '/api/users', testUser



          # $.post '/api/users/test3', user, (data, status) ->
          #   log "Adding a topic", "status", status, "data", data


Topics
-------

        ###
        testUser2 =
          name: "Philippa"
          _id: "tutor" 
          password: "testing"
          topics: [
            code: "212"
            permission: 'w'
          ]

        tutorAdded = $.post '/api/users', testUser2
        tutorLoggedIn = tutorAdded.then ->
          $.post '/api/login', testUser2
    
        ###


Adding a topic check

        topic =
          name: "NAC"
          _id: "212"
          types: ["Notes", "tutorial"]

        topicAdded = $.post '/api/topics', topic
        note "Topic addition", topicAdded

Getting a topic check

        note "Getting a topic", topicAdded.then ->
          $.get '/api/topics/212'


Login check
-----------

Checking that a user thats not signed up cannot log in.

        badUser =
          name: "rogue"
          _id: "test3" 
          password: "backstab"

        #failedLogin = userAdded.then ->
        #  $.post '/api/login', badUser
        #blame "Invalid user", failedLogin

Checking that user must have a correct password.

        forgetfulTestUser = $.extend {}, testUser
        forgetfulTestUser.password = "rubish"

        #failedLogin2 = userAdded.then ->
        #  $.post '/api/login', forgetfulTestUser
        #blame "Invalid password", failedLogin2

Checking that a user can login (this must be the last login so that we can use it later).

        userLoggedIn = $.when(userAdded, topicAdded).then ->
          $.post '/api/username', testUser

        note "Log in", userLoggedIn
        

Update user info
----------------

        testUserUpdate =
          name: "test1"
          _id: "test3" 
          password: "testing"
          topics: [
            code: "212"
            permission: 'w'
          ]
          email: "Update@test.com"
          facebook: "test@facebook.com"

        userUpdated = $.when(userAdded, userLoggedIn).then ->
          $.post '/api/users/test3', testUserUpdate
        note "Update Check", userUpdated 


        note "Getting a user", userUpdated.then ->
          $.get '/api/users/test3'





File
----

        
        

If the user is logged in then he can add a file

        file =
          name: "file"
          _id: "File1" 
          path: "/home/app"
          owner: "test3"
          topicCode: "212"
          type: "tutorial"
        
        fileAdded = $.when(userLoggedIn, topicAdded).then ->
          $.post '/api/topics/212/files', file
        note "File added", fileAdded


We then check if we can get a file

        note "Getting a file", fileAdded.then ->
          $.get '/api/topics/212/files/File1'

Also check that we cannot add a file to someone elses topic

        badFile =
          name: "file"
          _id: "rougeFile" 
          path: "/home/app"
          owner: "test3"
          topicCode: "reallyWrong"

        blame "Bad file permission", $.when(userLoggedIn, topicAdded).then ->
          $.post '/api/topics/reallyWrong/files', badFile

Question
--------

Adding a question
Getting a question check

        question =
          owner: "test3"
          position: "100"
          text: "question 1"



We add a question

        questionAdded = fileAdded.then -> 
          $.post '/api/topics/212/files/File1/questions', question
        note "Question Check", questionAdded

We then check if we can get a question

        note "Getting a question", questionAdded.then (questionId) ->
          $.get "/api/topics/212/files/File1/questions/#{questionId}"


------------------------------------
Adding an answer
Getting an answer check
------------------------------------

        answer =
          owner: "test3"
          rank: 5 
          text: "Answer 1"

We add an answer


        answerAdded = questionAdded.then (questionId) ->
          $.post "/api/topics/212/files/File1/questions/#{questionId}/answers", answer
        note "Answer Check", answerAdded

We then check if we can get an answer

        
        note "Getting an answer", $.when(answerAdded, questionAdded).then (answer, question) ->
          $.get "/api/topics/212/files/File1/questions/#{question[0]}/answers/#{answer[0]}"


---------------------------------------
Adding a comment to a question
Getting a comment from a question check
---------------------------------------

        commentQ =
          owner: "test3"
          text: "comment Q"

We add a comment for a question

        commentQAdded = questionAdded.then (questionId) ->
          $.post "/api/topics/212/files/File1/questions/#{questionId}/comments", commentQ
        note "Comment Q Check", commentQAdded
        
We then check if we can get a comment from a question

        note "Getting a comment from a question", $.when(commentQAdded, questionAdded).then (comment, question) ->
          console.log question[0]
          $.get "/api/topics/212/files/File1/questions/#{question[0]}/comments/#{comment[0]}"

---------------------------------------
Adding a comment to an answer
Getting a comment from an answer check
---------------------------------------

        commentA =
          owner: "test3"
          text: "comment A"

We add a comment for an answer

        commentAAdded = $.when(answerAdded, questionAdded).then (answer, question) ->
          $.post "/api/topics/212/files/File1/questions/#{question[0]}/answers/#{answer[0]}/comments", commentA
        note "Comment A Check", commentAAdded
        

We then check if we can get a comment from an answer

        note "Getting a comment from an answer", $.when(commentAAdded, answerAdded, questionAdded).then (comment, answer, question) ->
          $.get "/api/topics/212/files/File1/questions/#{question[0]}/answers/#{answer[0]}/comments/#{comment[0]}"


----

Check for list of questions and files

        # question2 =
        #   owner: "test3"
        #   position: "100"
        #   text: "question 2"
        
        # question2Added = fileAdded.then ->
        #   $.post '/api/topics/212/files/File1/questions', question2
        # note "Question 2 Check", question2Added

        # note "Getting question 2", question2Added.then ->
        #   $.get '/api/topics/212/files/File1/questions/Q2'

        # note "Feed check", $.when(questionAdded, question2Added).then ->
        #   $.get '/api/feeds/test3'
      
Events
------

        topic1 =
          name: "OS"
          _id: "211"

        topicAdded1 = $.post '/api/topics', topic1
        note "Topic addition", topicAdded1

        file1 =
          name: "file"
          _id: "File2" 
          path: "/home/app"
          owner: "test3"
          topicCode: "211"
          type: "solution"
        
        fileAdded1 = $.when(userLoggedIn, topicAdded1).then ->
          $.post '/api/topics/212/files', file1
        note "File added 1", fileAdded1

        note "Event list", fileAdded.then ->
          $.get '/api/events'


Ranking
-------

        voteUp = $.when(answerAdded, questionAdded).then (answer, question) ->
          $.post "/api/topics/212/files/File1/questions/#{question[0]}/answers/#{answer[0]}/voteUp/test3", commentA
        note "Vote up check", voteUp

        voteUp1 = $.when(answerAdded, questionAdded).then (answer, question) ->
          $.post "/api/topics/212/files/File1/questions/#{question[0]}/answers/#{answer[0]}/voteUp/test", commentA
        note "Vote up check", voteUp1

        note "Getting votes for", $.when(voteUp, answerAdded, questionAdded).then (vote, answer, question) ->
          $.get "api/topics/212/files/File1/questions/#{question[0]}/answers/#{answer[0]}/voteUp"

        voteDown = $.when(answerAdded, questionAdded).then (answer, question) ->
          $.post "/api/topics/212/files/File1/questions/#{question[0]}/answers/#{answer[0]}/voteDown/test3", commentA
        note "Vote down check", voteDown

        note "Getting votes against", $.when(voteDown, answerAdded, questionAdded).then (vote, answer, question) ->
          $.get "api/topics/212/files/File1/questions/#{question[0]}/answers/#{answer[0]}/voteDown"

      
          



