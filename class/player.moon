export class Player
  new: (@x, @y) =>
    @w, @h = 40, 40
    @speed = 300

  update: (dt) =>
    if love.keyboard.isDown 'left'
      @x -= @speed * dt
    elseif love.keyboard.isDown 'right'
      @x += @speed * dt
    if love.keyboard.isDown 'up'
      @y -= @speed * dt
    elseif love.keyboard.isDown 'down'
      @y += @speed * dt

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .rectangle 'fill', @x, @y, @w, @h
