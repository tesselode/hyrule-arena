export class Follower extends Enemy
  new: (state, x, y) =>
    super state, x, y, 12, 12

    @image = images.blob
    @speed = 50

  update: (dt) =>
    -- move towards the player
    player = @state.player
    if @knockback == false
      @velocity = (player\getCenter! - @getCenter!)\normalized! * @speed

    super\update dt
