module.exports = (authType) ->
  switch authType
    when 'noAuth' then require './noAuthHandler'
    when 'simpleAuth' then require './simpleAuth'
    when 'multiUser' then require './multiUserAuth'
    when 'publicKey' then require './publicKeyAuth'
    when 'multiContainerAuth' then require './multiContainerAuth'
    else null
