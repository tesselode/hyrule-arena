export class Follower extends Enemy
  new: (world, x, y) =>
    super world, x, y

    @speed = 100

  update: (dt) =>
    -- move towards the player
    player = gamestate.current!.map.player --this is bad fix it later
    if @knockback == false
      @velocity = (player\getCenter! - @getCenter!)\normalized! * @speed

    super\update dt
