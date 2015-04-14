export class Octorok extends Enemy
  new: (state, x, y) =>
    super state, x, y
    @speed = 150
    @direction = 0

    --loop movement pattern
    @movementPattern!
    @timer\recur (-> @movementPattern!), 4

  switchDirection: =>
    @velocity = vector.new(@speed, 0)\rotated util.trandom {0, math.pi / 2, math.pi, -math.pi / 2}

  movementPattern: =>
    @switchDirection!
    @timer\delay ->
        @switchDirection!,
      2
    @timer\delay ->
        @velocity = vector.new(0, 0),
      3.5
    @timer\delay ->
        projectile = Projectile @state, @getCenter!.x, @getCenter!.y, 10, 10, 800, @direction
        projectile.isEnemy = true,
      3.75

  update: (dt) =>
    collisions = super\update dt

    --get facing direction
    if @velocity\len! != 0
      @direction = math.atan2 @velocity.y, @velocity.x

  draw: =>
    super\draw!

    --debug stuff - shows which way the enemy is facing
    --shamelessly copied straight from the player
    with love.graphics
      .setColor 255, 255, 255, 255
      .setLineWidth 3
      x, y, w, h = @state.world\getRect self
      .circle 'line', x + w/2, y + h/2, w/2
      directionLine = vector.new(20, 0)\rotated(@direction)
      .line x + w/2, y + h/2, x + w/2 + directionLine.x, y + h/2 + directionLine.y