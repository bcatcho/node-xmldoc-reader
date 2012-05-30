fs = require "fs"
xml2js = require "xml2js"

exports.index = (req, res) ->
  res.render 'index', { title: 'Express' }
  
exports.docs = (req, res) ->
  res.render 'index', { title: 'Documentation' }


loadXmlFile = (file, fn) ->
  parser = new xml2js.Parser()
  fs.readFile file, (err, data) ->
    parser.parseString data, (err, result) ->
      fn err, result

exports.specificDoc = (req, res) ->
  loadXmlFile "sampleXml.xml", (err, data) ->
    members = data.members.member
    assembly = req.params.assembly.toLowerCase()
    method = req.params.method.toLowerCase()
    documentation =
      name: ""
      summary: ""
      remarks: ""
      seealso: ""

    for m in members
      name = m["@"].name.toLowerCase()
      regex = new RegExp("m:#{assembly}.#{method}.*", "i")
      if (regex.test name)
        documentation =
          name: m["@"].name
          summary: m.summary ? ""
          remarks: m.remarks ? ""
          seealso: m.seealso["#"] ? ""

    res.render 'index', { title: "#{assembly}/#{method}", doc: documentation }
