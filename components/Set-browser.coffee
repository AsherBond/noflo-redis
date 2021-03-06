noflo = require 'noflo'

# @runtime noflo-browser
# @name Set

class Set extends noflo.AsyncComponent
  constructor: ->
    @inPorts = new noflo.InPorts
      key:
        datatype: 'string'
      value:
        datatype: 'string'
      url:
        datatype: 'string'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
      error:
        datatype: 'object'

    super 'value', 'error'

  doAsync: (value, callback) ->
    @outPorts.error.send new Error 'Not yet supported in browser'
    callback()

exports.getComponent = -> new Set
