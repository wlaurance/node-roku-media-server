express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
dir = process.env.VIDSTREAMDIR
fs = require 'fs'

app = express()
# Add Connect Assets
app.use assets()
# Set the public folder as static assets
app.use express.static(dir)
app.use express.directory(dir)
# Set View Engine
app.set 'view engine', 'jade'
# Get root_path return index view
app.get '/', (req, resp) -> 
  resp.render 'index'
vid = require('vid-streamer')
app.get /videos/, vid
vid.settings(
  mode:"Development"
  forceDownload:false
  random:false
  rootFolder:dir + '/'
  rootPath:"videos/"
  server:"VidStreamer.js/0.1.2"
)
app.get '/listings', (req, res)->
  fs.readdir dir, (error, files)->
    throw error if error
    res.send 200, files

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000
# Start Server
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."
