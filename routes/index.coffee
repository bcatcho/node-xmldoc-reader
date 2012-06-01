csharpxmlreader = require "../lib/csharpxmlreader"

routes = (app) ->
  _docs = {}
  csharpxmlreader.load "sampleXml.xml",
    (result) -> _docs = result

  app.get "/", (req, res) ->
    res.render 'index', { title: 'Express' }
    
  app.get "/docs", (req, res) ->
    res.render 'docs', { title: 'Documentation', doc: _docs }

  app.get "/docs/:route", (req, res) ->
    route = req.params.route.toLowerCase()
    documentation = _docs?[route]
    res.render 'docClass', { title: "#{route}", doc: documentation }

  app.get "/docs/:route/:verb", (req, res) ->
    route = req.params.route.toLowerCase()
    verb = req.params.verb.toLowerCase()
    documentation = _docs?[route]?[verb]
    res.render 'docMethod', { title: "#{route}/#{verb}", doc: documentation }

module.exports = routes
