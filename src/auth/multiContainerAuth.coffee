bunyan  = require 'bunyan'
log     = bunyan.createLogger name: 'multiContainerAuth'
env     = require '../env'


fs = require('fs')


#tuples = env.assert 'AUTH_TUPLES'
tuples = process.env['AUTH_TUPLES']
tuples_file = process.env['AUTH_TUPLES_FILE']

unless (tuples || tuples_file)
  console.error "Configuration error: Environment variables AUTH_TUPLES and AUTH_TUPLES_FILE not set."
  process.exit(1)

#
security = {}
containers = {}

if tuples
  for tuple in tuples.split ';'
    [user, password, container] = tuple.split ':'
    security[user] = password
    containers[user] = container
else
  if tuples_file
    contents = fs.readFileSync(tuples_file, 'utf8');

    log.info {f: tuples_file}, 'Read auth data'

    for tuple in contents.split("\n")
      [user, password, container] = tuple.split ':'
      security[user] = password
      containers[user] = container


#
module.exports = (session) ->
  # return function
  f = (ctx) ->
    if ctx.method is 'password'
      if security[ctx.username] is ctx.password
        log.info {user: ctx.username}, 'Authentication succeeded'

        # set user to session
        session.sessdata.username = ctx.username
        session.sessdata.container = containers[ctx.username]

        log.info {s: session.sessdata}, 'Set data to session'

        return ctx.accept()
      else
        log.warn {user: ctx.username, password: ctx.password}, 'Authentication failed'
    ctx.reject(['password'])


  #
  return f

