CONFIG = require 'config'
__ = CONFIG.universalPath
_ = __.require 'builders', 'utils'
{ crawlPeriod, debounceDelay } = CONFIG.debouncedEmail

waitingEmails = __.require('level', 'base').simpleAPI 'waiting'
sendDebouncedEmail = require './send_debounced_email'

module.exports = ->
  setInterval crawl, crawlPeriod

# key structure: sendEmailFunctionName:id:time

crawl = ->
  waitingEmails.sub.createReadStream()
  .on 'data', onData

onData = (data)->
  {key, value} = data
  [domain, id, time] = key.split ':'

  # if the last event happened more than debounceDelay ago
  if _.expired time, debounceDelay
    sendDebouncedEmail[domain](id)
    .then cleanDb.bind(null, key)

cleanDb = (key)->
  waitingEmails.del key
