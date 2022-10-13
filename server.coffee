fs        = require 'fs'
ssh2      = require 'ssh2'
bunyan    = require 'bunyan'
log       = bunyan.createLogger name: 'sshServer'
handlerFactory  = require './src/session-handler-factory'

sshPort         = process.env.PORT or 22
httpPort        = process.env.HTTP_PORT or 80
ip              = process.env.IP or '0.0.0.0'
keypath         = process.env.KEYPATH
container       = process.env.CONTAINER
shell           = process.env.CONTAINER_SHELL
authMechanism   = process.env.AUTH_MECHANISM
authenticationHandler = require('./src/auth') authMechanism

exitOnConfigError = (errorMessage) ->
  console.error "Configuration error: #{errorMessage}"
  process.exit(1)

#exitOnConfigError 'No CONTAINER specified'                    unless container
exitOnConfigError 'No KEYPATH specified'                      unless keypath
exitOnConfigError 'No CONTAINER_SHELL specified'              unless shell
exitOnConfigError 'No AUTH_MECHANISM specified'               unless authMechanism
exitOnConfigError "Unknown AUTH_MECHANISM: #{authMechanism}"  unless authenticationHandler

options =
  {                                                                                         
    hostKeys: [fs.readFileSync(keypath)]                                                    
  }

sessionFactory = handlerFactory container, shell

sshServer = new ssh2.Server options, (client, info) ->
  session = sessionFactory.instance()
  log.info clientIp: info.ip, 'Client connected'

  session.sessdata.username = ""
  session.sessdata.container = ""

  if authMechanism=="multiContainerAuth"
    client.on 'authentication', authenticationHandler(session)

    client.on 'ready', -> client.on('session', session.myhandler())
  else
    # default - not depend on session
    client.on 'authentication', authenticationHandler

    client.on 'ready', -> client.on('session', session.handler)



  #client.on 'ready', -> client.on('session', session.handler)
  #client.on 'ready', -> client.on('session', -> log.info {u: username}, "do ready")
  #client.on 'ready', -> client.on('session', session.myhandler(session.sessdata.username))


  client.on 'end', ->
    log.info clientIp: info.ip, 'Client disconnected'
    session.close()

sshServer.listen sshPort, ip, ->
  log.info 'Docker-SSH ~ Because every container should be accessible'
  log.info {host: @address().address, port: @address().port}, 'Listening'
