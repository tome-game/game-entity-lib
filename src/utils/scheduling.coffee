do (root = global ? window) ->

  root.schedule = (ms, fn) ->
    setTimeout(fn, ms)

  root.unschedule = (timeout_id) ->
    clearTimeout(timeout_id)

  root.async = (fn) ->
    schedule 0, fn
