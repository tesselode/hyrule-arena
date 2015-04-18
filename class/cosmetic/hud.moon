export class HUD extends Common
  new: (@state) =>
    super!

    @maxHealth = 10
    @health = @maxHealth

    @y = -100

  flyDown: =>
    @maxHealth = 10
    @health = @maxHealth
    @tween\to(self, 1.5, {y: 10})\ease('elasticinout')

  flyUp: =>
    --@tween\to(self, 1.5, {y: -50})\ease('elasticinout')
    @y = -100

  update: (dt) =>
    super dt

    --update heart count
    if @state.gameFlow.state == 'gameplay'
      with @state.player
        @maxHealth = .maxHealth
        @health = .health

  draw: (topLeftX, topLeftY) =>
    for i = 1, @maxHealth
      with love.graphics
        interval = images.heartFull\getWidth!
        .setColor 255, 255, 255, 255
        if i > @.health
          .draw images.heartEmpty, topLeftX + 5 + (i - 1) * 16, topLeftY + @y, 0, 1, 1
        else
          .draw images.heartFull, topLeftX + 5 + (i - 1) * 16, topLeftY + @y, 0, 1, 1

    with love.graphics
      .setColor 0, 0, 0, 255
      .setFont fonts.menu
      .print 'Score: '..@state.gameFlow.score..' x '..@state.gameFlow.multiplier, topLeftX + 5, topLeftY + @y + 21
