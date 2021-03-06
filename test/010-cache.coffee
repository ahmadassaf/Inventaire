CONFIG = require('config')
__ = CONFIG.universalPath
_ = __.require 'builders', 'utils'

should = require 'should'
expect = require('chai').expect
sinon = require 'sinon'

promises_ = __.require 'lib', 'promises'
Promise = promises_.Promise

cache_ = __.require 'lib', 'cache'

mookPromise = hashKey = (key)->
  promises_.resolve _.hashCode(key)

Ctx =
  method: (key)-> hashKey key + @value
  failingMethod: (key)-> promises_.reject("Jag är Döden")
  value: -> _.random(1000)

describe 'CACHE', ->
  describe 'get', ->
    it "should return a promise", (done)->
      p = cache_.get('whatever', mookPromise.bind(null, 'yo'))
      p.should.have.property 'then'
      p.should.have.property 'catch'
      done()

    it "should accept a key and a promisified method", (done)->
      key = 'whatever'
      cache_.get(key, mookPromise.bind(null, key))
      .then -> done()

    it "should compute ones and cache for the nexts", (done)->
      spy = sinon.spy()
      key = '007'
      hash = _.hashCode(key)
      spiedHash = (key)->
        spy()
        return hashKey(key)

      method = spiedHash.bind(null, key)
      cache_.get(key, method).then (res)->
        res.should.equal hash
        cache_.get(key, spiedHash.bind(null, key)).then (res)->
          res.should.equal hash
          cache_.get(key, spiedHash.bind(null, key)).then (res)->
            res.should.equal hash
            # MOUAHAHA YOU WONT SEE ME (◣_◢)
            cache_.get('006', spiedHash.bind(null, '006')).then (res)->
              res.should.equal _.hashCode('006')
              cache_.get(key, spiedHash.bind(null, key)).then (res)->
                res.should.equal hash
                # DHO [>.<]
                spy.callCount.should.equal 2
                done()

    it "should also accept an expiration timespan", (done)->
      cache_.get('samekey', Ctx.method)
      .then (res1)->
        cache_.get('samekey', Ctx.method.bind(null, 'different arg'), 10000)
        .then (res2)->
          cache_.get('samekey', Ctx.method.bind(null, 'different arg'), 0)
          .then (res3)->
            _.log [res1, res2, res3], 'results'
            res1.should.equal res2
            res2.should.not.equal res3
            done()

    it "should return the outdated version if the new version returns an error", (done)->
      cache_.get('doden', Ctx.method.bind(null, 'Vem är du?'), 0)
      .then (res1)->
        # returns an error: should return old value
        cache_.get('doden', Ctx.failingMethod.bind(null, 'Vem är du?'), 0)
        .then (res2)->
          # the error shouldnt have overriden the value
          cache_.get('doden', Ctx.method.bind(null, 'Vem är du?'), 5000)
          .then (res3)->
            _.log [res1, res2, res3], 'results'
            res1.should.equal res2
            res1.should.equal res3
            done()

    it "should cache non-error empty results", (done)->
      spy = sinon.spy()
      empty = (key)->
        spy()
        return promises_.resolve _.noop(key)

      cache_.get 'gogogo', empty
      .then (res1)->
        expect(res1).to.equal undefined
        cache_.get 'gogogo', empty
        .then (res2)->
          expect(res2).to.equal undefined
          spy.callCount.should.equal 1
          done()