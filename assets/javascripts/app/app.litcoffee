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

        userAdded = $.post '/api/users', testUser
        note "Signup Check", userAdded

We then check that we can't make a duplicate sign up.

        note "Duplicate Check", userAdded.then ->
          $.post '/api/users', testUser

          # $.post '/api/users/test3', user, (data, status) ->
          #   log "Adding a topic", "status", status, "data", data

Login check
-----------

Checking that a user that's not signed up cannot log in.

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

        userLoggedIn = $.when(userAdded).then ->
          $.post '/api/login', testUser

        note "Log in", userLoggedIn

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

        topicAdded = $.post '/api/topics', topic
        note "Topic addition", topicAdded

Getting a topic check

        note "Getting a topic", topicAdded.then ->
          $.get '/api/topics/212'

File
----

If the user is logged in then he can add a file

        file =
          name: "file"
          _id: "File1" 
          path: "/home/app"
          owner: "test3"
          topicCode: "212"
        
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
          _id: "Q1" 
          owner: "testOwner"
          filePosition: "100"
          text: "question 1"



We add a question

        questionAdded = fileAdded.then -> 
          $.post '/api/topics/212/files/File1/questions', question
        note "Question Check", questionAdded

We then check if we can get a question

        note "Getting a question", questionAdded.then ->
          $.get '/api/topics/212/files/File1/questions/Q1'


------------------------------------
Adding an answer
Getting an answer check
------------------------------------

        answer =
          _id: "A1" 
          owner: "testOwner"
          rank: 5 
          text: "Answer 1"

We add an answer


        answerAdded = questionAdded.then ->
          $.post '/api/topics/212/files/File1/questions/Q1/answers', answer
        note "Answer Check", answerAdded

We then check if we can get an answer

        
        note "Getting an answer", answerAdded.then ->
          $.get '/api/topics/212/files/File1/questions/Q1/answers/A1'


---------------------------------------
Adding a comment to a question
Getting a comment from a question check
---------------------------------------

        commentQ =
          _id: "testcomment1" 
          owner: "testOwnerComment"
          text: "comment Q"

We add a comment for a question

        commentQAdded = questionAdded.then ->
          $.post '/api/topics/212/files/File1/questions/Q1/comments', commentQ
        note "Comment Q Check", commentQAdded
        
We then check if we can get a comment from a question

        note "Getting a comment from a question", commentQAdded.then ->
          $.get '/api/topics/212/files/File1/questions/Q1/comments/testcomment1'

---------------------------------------
Adding a comment to an answer
Getting a comment from an answer check
---------------------------------------

        commentA =
          _id: "testcomment2" 
          owner: "testOwnerComment"
          text: "comment A"

We add a comment for an answer

        commentAAdded = answerAdded.then ->
          $.post '/api/topics/212/files/File1/questions/Q1/answers/A1/comments', commentA
        note "Comment A Check", commentAAdded
        

We then check if we can get a comment from an answer


        note "Getting a comment from an answer", commentAAdded.then ->
          $.get '/api/topics/212/files/File1/questions/Q1/answers/A1/comments/testcomment2'


----

Check for list of questions and files



        question2 =
          _id: "Q2" 
          owner: "testOwner"
          filePosition: "100"
          text: "question 2"
        
        question2Added = fileAdded.then ->
          $.post '/api/topics/212/files/File1/questions', question2
        note "Question 2 Check", question2Added

        note "Getting question 2", question2Added.then ->
          $.get '/api/topics/212/files/File1/questions/Q2'

        note "Feed check", $.when(questionAdded, question2Added).then ->
          $.get '/api/feeds/test3'
      
Events
------

        note "Event list", fileAdded.then ->
          $.get '/api/events'



        
          



