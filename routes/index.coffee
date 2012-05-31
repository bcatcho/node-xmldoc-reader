csharpxmlreader = require "../lib/csharpxmlreader"

_docs = {}
csharpxmlreader.load "sampleXml.xml",
  (result) -> _docs = result

exports.index = (req, res) ->
  res.render 'index', { title: 'Express' }
  
exports.docs = (req, res) ->
  # TODO this should return all classes/methods like janrains
  res.render 'index', { title: 'Documentation' }

exports.docClass = (req, res) ->
  route = req.params.route.toLowerCase()
  documentation = _docs?[route]
  res.render 'docClass', { title: "#{route}", doc: documentation }

exports.docMethod = (req, res) ->
  route = req.params.route.toLowerCase()
  verb = req.params.verb.toLowerCase()
  documentation = _docs?[route]?[verb]
  res.render 'docMethod', { title: "#{route}/#{verb}", doc: documentation }

