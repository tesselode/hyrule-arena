export class HUD extends Common
  new: (@state) =>
    super!

    @maxHealth = 10
    @health = @maxHealth

    @y = -50

  flyDown: =>
    @maxHealth = 10
    @health = @maxHealth
    @tween\to(self, 1.5, {y: 10})\ease('elasticinout')

  flyUp: =>
    --@tween\to(self, 1.5, {y: -50})\ease('elasticinout')
    @y = -50

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
        .setColor 255, 255, 255, 255
        if i > @.health
          .draw images.heartEmpty, topLeftX + 10 + (i - 1) * 30, topLeftY + @y, 0, 1.5, 1.5
        else
          .draw images.heartFull, topLeftX + 10 + (i - 1) * 30, topLeftY + @y, 0, 1.5, 1.5
