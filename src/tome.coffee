# Setup tome namespace
do (root = global ? window) ->
  (root.tome ?={}).version = '0.0.1'
  module.exports = root.tome
  return
