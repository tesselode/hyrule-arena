export class Follower extends Enemy
  new: (state, x, y) =>
    super state, x, y

    @speed = 50

  update: (dt) =>
    -- move towards the player
    player = @state.player
    if @knockback == false
      @velocity = (player\getCenter! - @getCenter!)\normalized! * @speed

    super\update dt
