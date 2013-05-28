Utilities.

    define ['jquery', 'vendor/js-dump', 'vendor/moment'], ($, Dump) ->

Utility to display output without opening the console (and also there).

      log = (label, data...) ->
        for name, i in data by 2
          json = {}
          json[name] = data[i + 1]
          $('body').prepend "<pre>#{Dump.parse json}</pre>"
        $('body').prepend timeStamp $("<h4></h4>")
        $('body').prepend "<h1>#{label}</h1>"

        console.log label
        for d in data
          console.log d

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

      {log}

