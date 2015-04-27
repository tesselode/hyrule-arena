export class Octorok extends Enemy
  new: (state, x, y) =>
    super state, x, y

    @image = images.octorok
    @speed = 65
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
    @timer\delay (-> OctorokBullet @state, @getCenter!.x, @getCenter!.y, @direction), 3.75

  update: (dt) =>
    collisions = super dt

    --get facing direction
    if @velocity\len! != 0
      @direction = math.atan2 @velocity.y, @velocity.x

  draw: =>
    @drawPainEffects ->
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



export class HardOctorok extends Enemy
  new: (state, x, y) =>
    super state, x, y

    @speed = 100
    @direction = 0

    --loop movement pattern
    @movementPattern!
    @timer\recur (-> @movementPattern!), 2

  switchDirection: =>
    @velocity = vector.new(@speed, 0)\rotated util.trandom {0, math.pi / 2, math.pi, -math.pi / 2}

  movementPattern: =>
    @switchDirection!
    @timer\delay ->
        @velocity = vector.new(0, 0),
      1.5
    @timer\delay (-> OctorokBullet @state, @getCenter!.x, @getCenter!.y, @direction), 1.75

  update: (dt) =>
    collisions = super dt

    --get facing direction
    if @velocity\len! != 0
      @direction = math.atan2 @velocity.y, @velocity.x

  draw: =>
    @drawPainEffects ->
      cx, cy = @getCenter!\unpack!
      image = images.octorok
      w,h = image\getDimensions!

      with love.graphics
        .setColor 255, 255, 255
        .draw images.blueOctorok,
          cx, cy,
          @direction,
          1, 1,
          w/2, h/2

  drawShadow: =>
    super 0, -6
