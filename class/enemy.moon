export class Enemy extends Physical
  new: (world, x, y) =>
    super world, x, y, 40, 40
    @velocity = vector.new(-50, -50)
    @filter = (other) =>
      if other.id == 'wall'
        return 'slide'
      else
        return false

  takeDamage: (other) =>
    if other.__class == Player
      --knockback movement tween
      --get starting position
      x, y = @world\getRect self
      @tweenPosition = vector.new x + 20, y + 20
      --get ending position
      tweenGoal = @tweenPosition + vector.new(100, 0)\rotated(other.direction)
      --perform the tween
      @knockbackTween = flux.to(@tweenPosition, 0.3, {x: tweenGoal.x, y: tweenGoal.y})\onupdate(->
        --move the bump object to match the tween
        @world\move self, @tweenPosition.x - 20, @tweenPosition.y - 20, @filter)

  draw: =>
    super\draw!
