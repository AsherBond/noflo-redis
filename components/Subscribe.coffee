noflo = require 'noflo'
{RedisComponent} = require '../lib/RedisComponent.coffee'

class Subscribe extends RedisComponent
  constructor: ->
    @inPorts =
      channel: new noflo.Port
    @outPorts =
      out: new noflo.Port
      error: new noflo.Port

    super 'channel'

  doAsync: (channel, callback) ->
    unless @redis
      callback new Error 'No Redis connection available'
      return

    if channel.indexOf('*') isnt -1
      @doPatternSubscribe channel, callback
      return

    @doSubscribe channel, callback

  doSubscribe: (channel, callback) ->
    @redis.subscribe channel, (err, reply) =>
      return callback err if err
      callback()

    @redis.on 'message', (chan, msg) =>
      @outPorts.out.beginGroup chan
      @outPorts.out.send msg
      @outPorts.out.endGroup()
      @outPorts.out.disconnect()

  doPatternSubscribe: (pattern, callback) ->
    @redis.psubscribe pattern, (err, reply) =>
      return callback err if err
      callback()

    @redis.on 'pmessage', (patt, chan, msg) =>
      @outPorts.out.beginGroup chan
      @outPorts.out.send msg
      @outPorts.out.endGroup()
      @outPorts.out.disconnect()

exports.getComponent = -> new Subscribe