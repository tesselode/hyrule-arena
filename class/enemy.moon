export class Enemy extends Physical
  new: (world, x, y) =>
    super world, x, y, 40, 40
    @velocity = vector.new(-50, -50)
    @filter = (other) =>
      if other.__class == Wall
        return 'slide'
      else
        return false

  takeDamage: (other) =>
    if other.__class == Player
      --knockback movement tween
      --get starting position
      x, y, w, h = @world\getRect self
      @tweenPosition = vector.new x + w/2, y + h/2
      --get ending position
      tweenGoal = @tweenPosition + vector.new(100, 0)\rotated(other.direction)
      --perform the tween
      @knockbackTween = flux.to(@tweenPosition, 0.3, {x: tweenGoal.x, y: tweenGoal.y})\onupdate(->
        --move the bump object to match the tween
        @world\move self, @tweenPosition.x - w/2, @tweenPosition.y - h/2, @filter)

  draw: =>
    super\draw!
