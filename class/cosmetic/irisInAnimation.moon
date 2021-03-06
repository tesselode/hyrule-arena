export class IrisInAnimation extends Common
  new: (@state) =>
    super!

    @canvas = love.graphics.newCanvas BASE_WIDTH, BASE_HEIGHT
    @position = vector!
    @radius = 1000

  closeIn: =>
    @tween\to self, 1, {radius: 50}

  openUp: =>
    @tween\to(self, 1, {radius: 1000})\ease('quadin')

  update: (dt) =>
    super dt

    --follow player
    if @state.gameFlow.state == 'gameplay'
      roomX, roomY = @state.map.currentRoom\getWorldPosition!
      playerX, playerY = @state.player\getCenter!\unpack!
      @position = vector playerX - roomX, playerY - roomY

  render: =>
    with love.graphics
      @canvas\clear 0, 0, 0, 255
      @canvas\renderTo(->
        x, y = @position\unpack!
        .setColor 255, 255, 255, 255
        .circle 'fill', x, y, @radius)

  draw: (topLeftX, topLeftY) =>
    with love.graphics
      .setBlendMode 'multiplicative'
      .setColor 255, 255, 255, 255
      .draw @canvas, topLeftX, topLeftY
      .setBlendMode 'alpha'
