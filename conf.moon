io.stdout\setvbuf'no'

love.conf = (t) ->
  with t.window
    .title = "Hyrule Arena"
    .width = 1280
    .height = 720
    .fullscreen = false
    .fullscreentype = 'desktop'
  t.identity = "Hyrule Arena"
