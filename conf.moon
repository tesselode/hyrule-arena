io.stdout\setvbuf'no'

love.conf = (t) ->
  with t.window
    .width = 1920
    .height = 1080
    .fullscreen = true
    .fullscreentype = 'desktop'
