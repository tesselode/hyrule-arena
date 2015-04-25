export class Paused
  pausedText = "PAUSED
Press Escape to exit
Press Enter to resume"

  new: =>

  enter: (@prevState) =>

  update: =>

  keypressed: (key) =>
    if key == 'return'
      gamestate.pop!
    elseif key == 'escape'
      love.event.quit!

  gamepadpressed: (gamepad, button) =>
    if button == 'start'
      gamestate.pop!

  draw: =>
    with love.graphics
      @prevState\draw!

      -- overlay rectangle
      .setColor 0, 0, 0, 100
      .rectangle 'fill', 0, 0, .getDimensions!

      .push 'all'

      .scale 2

      .setColor 255, 255, 255, 255
      .setFont fonts.title
      .printf pausedText, 0, 250, .getWidth!/2, 'center'

      .pop!
