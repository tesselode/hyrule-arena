export class Octorok extends Enemy
  new: (state, x, y) =>
    super state, x, y
    @speed = 75
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
        projectile = Projectile @state, @getCenter!.x, @getCenter!.y, 10, 10, 400, @direction
        projectile.isEnemy = true,
      3.75

  update: (dt) =>
    collisions = super dt

    --get facing direction
    if @velocity\len! != 0
      @direction = math.atan2 @velocity.y, @velocity.x

  draw: =>
    cx, cy = @getCenter!\unpack!
    image = images.octorok
    w,h = image\getDimensions!

    with love.graphics
      .setColor 255, 255, 255
      .draw images.octorok,
        cx, cy,
        @direction,
        1, 1,
        w/2, h/2

  drawShadow: =>
    super 0, -6
