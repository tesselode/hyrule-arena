export class HUD extends Common
  new: (@state) =>
    super!

    @maxHealth = 10
    @health = @maxHealth

    @y = -100

  flyDown: =>
    @maxHealth = 10
    @health = @maxHealth
    @tween\to(self, 1.5, {y: 0})

  flyUp: =>
    @tween\to(self, 1.5, {y: -50})

  update: (dt) =>
    super dt

    --update heart count
    if @state.gameFlow.state == 'gameplay'
      with @state.player
        @maxHealth = .maxHealth
        @health = .health

  draw: (topLeftX, topLeftY) =>
    buffer = 0

    for i = 1, @maxHealth
      with love.graphics
        interval = 8
        .setColor 255, 255, 255, 255
        if i > @.health
          .draw images.heartEmpty, topLeftX + buffer + (i - 1) * interval, topLeftY + @y, 0, 1, 1
        else
          .draw images.heartFull, topLeftX + buffer + (i - 1) * interval, topLeftY + @y, 0, 1, 1

    with love.graphics
      .setColor 255, 255, 255, 255
      .setFont fonts.menu
      .print 'Score: '..@state.gameFlow.score..' x '..@state.gameFlow.multiplier, topLeftX + buffer, topLeftY + @y + 8
