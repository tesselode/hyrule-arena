export class IrisInAnimation extends Common
  new: (@state) =>
    super!

    @canvas = love.graphics.newCanvas 1024, 576
    @position = vector!
    @radius = 2000

  closeIn: =>
    @tween\to self, 1, {radius: 100}

  openUp: =>
    @tween\to self, 1, {radius: 2000}

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

  draw: =>
    with love.graphics
      topLeftX, topLeftY = @state.camera.main\worldCoords 0, 0
      .setBlendMode 'multiplicative'
      .setColor 255, 255, 255, 255
      .draw @canvas, topLeftX, topLeftY
      .setBlendMode 'alpha'
