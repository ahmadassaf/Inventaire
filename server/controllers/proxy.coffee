__ = require('config').universalPath
_ = __.require 'builders', 'utils'
url = require 'url'
request = require 'request'
error_ = __.require 'lib', 'error/error'

{ Ip } = __.require 'models', 'tests/regex'
isIp = Ip.test.bind Ip
validProtocols = [ 'http:', 'https:' ]

module.exports.get = (req, res, next)->
  # removing both /api/proxy/ and https://inventaire.io/api/proxy/
  query = req.originalUrl.split('/api/proxy/')[1]

  { protocol, hostname } = url.parse query

  # in case the protocol is missing
  # the url parser still returns a defined protocol
  #   ex: url.parse('192.168.0.1:1234')
  #   => protocal = 192.168.0.1, hostname = 1234
  # thus the need to check it really is a valid protocol
  unless protocol in validProtocols
    return error_.bundle res, 'invalid protocol', 400, query

  unless validHostname hostname
    return error_.bundle res, 'invalid hostname', 400, query

  _.warn query, 'proxied query'
  request query
  .on 'error', ErrorHandler(res)
  .pipe res

validHostname = (hostname)->
  unless hostname? then return false
  # prevent access to resources behind the firewall
  if hostname is 'localhost' then return false
  # conservative rule to make sure the above
  # no-behind-firewall-snuffing restriction is respected
  if isIp hostname then return false
  return true

# assuming a request error is on the client's fault => 400
ErrorHandler = (res)-> (err)-> error_.handler res, err, 400
