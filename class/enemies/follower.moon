export class Follower extends Enemy
  new: (world, map, x, y) =>
    super world, map, x, y
    
    @speed = 100

  update: (dt) =>
    -- move towards the player
    player = @map.player
    if @knockback == false
      @velocity = (player\getCenter! - @getCenter!)\normalized! * @speed

    super\update dt
