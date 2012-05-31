csharpxmlreader = require "../lib/csharpxmlreader"

_docs = {}
csharpxmlreader.load "sampleXml.xml",
  (result) -> _docs = result

exports.index = (req, res) ->
  res.render 'index', { title: 'Express' }
  
exports.docs = (req, res) ->
  res.render 'index', { title: 'Documentation' }

exports.specificDoc = (req, res) ->
  [route, verb] = [req.params.route.toLowerCase(), req.params.verb.toLowerCase()]
  documentation = _docs?[route]?[verb]
  res.render 'index', { title: "#{route}/#{verb}", doc: documentation }

