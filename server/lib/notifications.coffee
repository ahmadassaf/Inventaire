__ = require('config').root
_ = __.require 'builders', 'utils'
levelBase = __.require 'level', 'base'
API = levelBase.simpleAPI('notifications')

module.exports =
  API: API
  db: API.raw

  getUserNotifications: (userId)->
    _.types arguments, 'string'
    params =
      gt: userId
      lt: userId + 'Z'
    return API.getStream(params)

  add: (userId, type, data)->
    _.types arguments, 'string', 'string', 'object'
    value = @getValue(type, data)
    key = @getKey(userId, value.time)
    _.info [key, value], 'key, value'
    API.put key, value

  getKey: (userId)-> userId + ':' + _.now()

  getValue: (type, data)->
    return value =
      type: type
      data: data
      status: 'unread'
      time: _.now()