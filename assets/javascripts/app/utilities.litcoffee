Utilities.

    define ['jquery', 'vendor/js-dump', 'vendor/moment'], ($, Dump) ->

Utility to display output without opening the console (and also there).

      coloredLog = (label, outTo, color, data...) ->
        for name, i in data by 2
          json = {}
          json[name] = data[i + 1]
          outTo.prepend "<pre>#{Dump.parse json}</pre>"
        outTo.prepend timeStamp $("<h4></h4>")
        outTo.prepend "<h2 style='color: #{color}'>#{label}</h2>"

        console.log label
        for d in data
          console.log d

      log = (label, args...) ->
        coloredLog label, $('body'), "black", args...

      counter = 0

      verify = (label, promise, successColor, failColor) ->
        placeholder = $("<div id='verify#{counter}'></div>")
        $('body').append placeholder
        promise.then (data, status) ->
          coloredLog label, placeholder, successColor, "data", data, "status", status
        , (error) ->
          coloredLog label, placeholder, failColor, "error", error


      note = (label, promise) ->
        verify label, promise, "#009900", "#ff4400"

      blame = (label, promise) ->
        verify label, promise, "#ff4400", "#009900"


Textual representation of current time.

      timeStamp = ($t) ->
        stamp = moment()
        formatted = stamp.format 'hh:mm:ss.SSS'
        display = ->
          $t.html "#{formatted}, #{stamp.fromNow()}"
        setInterval display, 30000
        display()
        $t


Export:

      {log, note, blame}

