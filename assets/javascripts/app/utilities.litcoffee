Utilities.

    define ['jquery'], ($) ->

Utility to display output without opening the console (and also there).

      log = (label, data...) ->
        printout = "<h1>#{label}<h4>#{timeStamp()}</h4></h1>"
        for name, i in data by 2
          printout += "<p><b>#{name}</b></p>"
          printout += "<p>#{data[i + 1]}</p>"
        $('body').prepend printout

        console.log label
        for d in data
          console.log d

Textual representation of current time.

      timeStamp = ->
        date = new Date
        ms = date.getMilliseconds()
        ms = Array(4-String(ms).length).join('0') + ms
        "#{date.getHours()}:#{date.getMinutes()}:#{date.getSeconds()}.#{ms}"


Export:

      {log}

