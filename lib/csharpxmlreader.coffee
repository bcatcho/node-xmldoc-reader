fs = require "fs"
xml2js = require "xml2js"

loadXmlFile = (fileName, callback) ->
  parser = new xml2js.Parser()
  data = fs.readFileSync fileName
  parser.parseString data, (err, result) ->
    callback err, result


docParser =
  parseMemberName: (member) ->
    name = member["@"].name.toLowerCase()

  parseMemberType: (member) ->
    @parseMemberName(member)[0]

  parseMember: (member, docs) ->
    memberType = @parseMemberType member
    parser = @memberTypeParser[memberType]
    if parser
      parser member, docs
    else
      console.log "no parser found for #{memberType}"

  memberTypeParser:
    m: (member, docs) ->
      regex = /m\:(\w+)\.(\w+)/i
      name = docParser.parseMemberName member
      matches = regex.exec name
      [closs, verb] = [matches[1], matches[2]]
      docs[closs] ?= {}
      docs[closs][verb] = member
      docs[closs][verb].name = "#{closs}/#{verb}"


convertToHeirarchicalObj = (rawDocs) ->
  members = rawDocs.members.member
  documentation = {}
  for m in members
    docParser.parseMember m, documentation
  documentation


exports.load = (fileName, callback) ->
  loadXmlFile fileName, (err, rawDocs) ->
    docs = convertToHeirarchicalObj rawDocs
    callback docs

