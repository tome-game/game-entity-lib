class tome.GameFrameStats
  @DEFAULT_STEP_DELTA = 1000 / 60

  current_frame_time: null
  last_frame_time: null
  last_frame_duration: null
  frames_per_second: 0
  frame_count: 0

  constructor: ->
    @current_frame_time = +new Date()

  step: (timestamp=+new Date()) ->
    @last_frame_time = @current_frame_time
    @current_frame_time = timestamp
    @last_frame_duration = @current_frame_time - @last_frame_time
    @frames_per_second = Math.floor @last_frame_duration / 1000.0
    @frame_count++
    return

  fps: ->
    @frames_per_second

  stepDelta: ->
    @last_frame_duration || GameFrameStats.DEFAULT_STEP_DELTA
