# Mdodule dependencies.

express = require('express')
routes = require('./routes')
flash = require "connect-flash"

app = module.exports = express.createServer()

# Configuration

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.cookieParser('yar')
  app.use express.session { cookie: { maxAge: 60000}, secret: 'yar'}
  app.use flash()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })


app.configure 'production', ->
  app.use express.errorHandler()


# Routes

app.get '/', routes.index
app.get '/docs', routes.docs
app.get '/docs/:route/:verb', routes.docMethod
app.get '/docs/:route', routes.docClass

app.listen 3000, ->
  console.log "Express server listening on port %d in %s mode",
    app.address().port,
    app.settings.env
