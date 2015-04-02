export class Player extends Physical
  new: (x, y) =>
    super x, y, 40, 40
    @speed = 300

  update: (dt) =>
    --movement
    if love.keyboard.isDown 'left'
      @velocity.x = -1
    elseif love.keyboard.isDown 'right'
      @velocity.x = 1
    else
      @velocity.x = 0
    if love.keyboard.isDown 'up'
      @velocity.y = -1
    elseif love.keyboard.isDown 'down'
      @velocity.y = 1
    else
      @velocity.y = 0
    @velocity = @velocity\normalized! * @speed

    super\update dt
