# expect = require('chai').expect
# should = require 'should'
# trycatch = require 'trycatch'
# request = require 'supertest'
# baseUrl = require('config').fullHost()

# __ = require('config').universalPath
# _ = __.require 'builders', 'utils'

# Promise = require 'bluebird'

# user_ = __.require 'lib','user/user'

# describe "user byUsername", ->
#   it "returns docs", (done)->
#     trycatch( ->
#       # bobby should have been added in fakeUsers
#       user_.byUsername('bobby')
#       .then (docs)->
#         docs.should.be.an.Array
#         docs.length.should.equal 1
#         docs[0].should.be.an.Object
#         _.log docs, 'docs byUsername'
#         done()
#       .catch (err)-> throw new Error(err)
#     , done)

# describe "usernameStartBy", ->
#   it "returns docs", (done)->
#     trycatch( ->
#       # bobby should have been added in fakeUsers
#       user_.usernameStartBy('bob')
#       .then (docs)->
#         docs.should.be.an.Array
#         docs.length.should.equal 1
#         docs[0].should.be.an.Object
#         _.log docs, 'docs usernameStartBy'
#         done()
#       .catch (err)-> throw new Error(err)
#     , done)

# describe "users fetch", ->
#   it "returns docs", (done)->
#     trycatch( ->
#       # bobby, tony, rocky should have been added in fakeUsers
#       promises = ['bobby', 'tony', 'rocky'].map (username)->
#         return user_.byUsername(username)

#       Promise.all(promises)
#       .then (proms)->
#         ids = proms.map (user)->
#           _.log user[0], 'user'
#           return user[0]._id
#         _.log ids, 'ids'
#         user_.db.fetch(ids)
#         .then (docs)->
#           _.log docs, 'docs'
#           docs.should.be.an.Array
#           docs.length.should.equal 3
#           docs.forEach (doc)-> doc.should.be.an.Object
#           done()
#       .catch (err)-> throw new Error(err)
#     , done)

#   it "return undefined docs when doc not found", (done)->
#     trycatch( ->
#       # johnnybegood should not be in fakeUsers
#       user_.db.fetch(['invalidId'])
#       .then (docs)->
#         _.log docs, 'docs'
#         docs.should.be.an.Array
#         docs.length.should.equal 1
#         expect(docs[0]).to.be.undefined
#         done()
#       .catch (err)-> throw new Error(err)
#     , done)

#   it "returns an array with defined and undefined docs", (done)->
#     trycatch( ->
#       # bobby, tony, rocky should have been added in fakeUsers
#       promises = ['tony', 'rocky'].map (username)->
#         return user_.byUsername(username)

#       Promise.all(promises)
#       .then (proms)->
#         ids = proms.map (user)->
#           _.log user[0], 'user'
#           return user[0]._id
#         _.log ids, 'ids'
#         ids.push 'invalidId'
#         user_.db.fetch(ids)
#         .then (docs)->
#           _.log docs, 'docs'
#           docs.should.be.an.Array
#           docs.length.should.equal 3
#           docs[0].should.be.an.Object
#           docs[1].should.be.an.Object
#           expect(docs[2]).to.be.undefined
#           done()
#       .catch (err)-> throw new Error(err)
#     , done)