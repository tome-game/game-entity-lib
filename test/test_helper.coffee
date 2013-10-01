
global.chai = require 'chai'
global.sinonChai = require 'sinon-chai'
global.sinon = require 'sinon'
global.expect = global.chai.expect
global.chai.use global.sinonChai

# Make sure we require the istrumented js
global.require_src = (src) ->
  require "../build/#{src}.js"

# Ensure namespace is defined
require_src 'tome'
