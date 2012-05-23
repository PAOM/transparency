express = require "express"
$       = require "jquery"
require("transparency").register $

app = express.createServer()

app.configure ->
  app.use app.router

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.get "/", (req, res) ->
  template = $ '<div><h1 class="title"></h1></div>'
  result   = template.render title: "Hello World!"
  res.send template.html()

app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env