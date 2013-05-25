express   =  require 'express'
engines   =  require 'consolidate'
httpProxy =  require 'http-proxy'

routes    =  require './routes'

exports.startServer = (config, callback) ->

  port = process.env.PORT or config.server.port

  app = express()
  server = app.listen port, ->
    console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

  app.configure ->
    app.set 'port', port
    app.set 'views', config.server.views.path
    app.engine config.server.views.extension, engines[config.server.views.compileWith]
    app.set 'view engine', config.server.views.extension

  app.configure ->
    app.use config.server.base, app.router
    app.use express.static(config.watch.compiledDir)

  app.configure 'development', ->
    app.use express.errorHandler()

  app.get '/', routes.index(config)

  # Redirect api requests (*all* HTTP verbs) to the Cloud
  apiProxy = new httpProxy.RoutingProxy
  app.all '/api/*', (req, res) ->
    console.log req.originalUrl
    req.url = req.url.replace "/api", ''
    apiProxy.proxyRequest req, res,
      host: 'localhost'
      port: 3333

  callback(server)

