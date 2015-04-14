export class Game extends Common
  new: =>
    super!

    --game world
    @world = bump.newWorld!
    @map = Map self

    --cameras
    @camera = {}
    with @camera
      .main = camera.new! --for resolution independence
      .main\zoomTo love.graphics.getHeight! / 576
      .world = camera.new!

    --game flow
    @gameFlow = {
      state: 'title'
    }

    --cosmetic stuff
    @cosmetic = {
      playerSpawnAnimation: PlayerSpawnAnimation self
      irisIn: {
        canvas: love.graphics.newCanvas 1024, 576
        radius: 2000
      }
    }

  startGame: =>
    @gameFlow.state = 'gameplay'
    @player = Player self, 512 - 16, 288 - 16

  update: (dt) =>
    super dt

    --get the current room
    room = @map.currentRoom
    rx, ry, rw, rh = room\getWorldRect!

    if @gameFlow.state == 'gameplay'
      --update the map
      @map\update dt

			-- update all instances in the active room
      items = @world\queryRect room\getWorldRect!
      for item in *items
        item\update dt

			-- delete instances
      for item in *items
        if item.delete
          item\onDelete!
          @world\remove item

      with @player
        -- keep track of which room the player is in
        {:x, :y} = \getCenter!
        _, _, width, height = @world\getRect @player
        if x < rx and .velocity.x < 0
          @map\exploreTo room.x - 1, room.y
        elseif x >= rx + rw and .velocity.x > 0
          @map\exploreTo room.x + 1, room.y
        elseif y < ry and .velocity.y < 0
          @map\exploreTo room.x, room.y - 1
        elseif y >= ry + rh and .velocity.y > 0
          @map\exploreTo room.x, room.y + 1

      if @player.health <= 0
        @gameFlow.state = 'game over'
        @tween\to @cosmetic.irisIn, 1, {radius: 100}

    --update camera
    x, y = room\getWorldCenter!
    @camera.world\lookAt util.interpolate(@camera.world.x, x, dt * 7), util.interpolate(@camera.world.y, y, dt * 7)

    --update cosmetic stuff
    @cosmetic.playerSpawnAnimation\update dt

  keypressed: (key) =>
    if key == 'return'
      if @gameFlow.state == 'title'
        @gameFlow.state == 'startingAnimation'
        @cosmetic.playerSpawnAnimation\start!

    if key == 'f1'
      @player.health = 0

    --controls
    if key == 'x'
      @player\attack!

  draw: =>
    --render iris in transition
    if @gameFlow.state == 'game over'
      with love.graphics
        @cosmetic.irisIn.canvas\clear 0, 0, 0, 255
        @cosmetic.irisIn.canvas\renderTo(->
          cameraX, cameraY = @camera.world\pos!
          playerX, playerY = @player\getCenter!.x, @player\getCenter!.y
          .setColor 255, 255, 255, 255
          .circle 'fill', playerX - cameraX + 512, playerY - cameraY + 288, @cosmetic.irisIn.radius)

    @camera.main\draw ->
      @camera.world\draw ->
        --draw all instances
        objects = @world\getItems!
        table.sort objects, (a, b) -> return a.depth < b.depth --sort objects by drawing order

        for object in *objects
          object\drawShadow!

        for object in *objects
          object\draw!

        --draw player spawn animation
        @cosmetic.playerSpawnAnimation\draw!

      --gui stuff
      topLeftX, topLeftY = @camera.main\worldCoords 0, 0
      if @gameFlow.state == 'gameplay'
        for i = 1, @player.maxHealth
          with love.graphics
            .setColor 255, 255, 255, 255
            if i > @player.health
              .draw images.heartEmpty, topLeftX + 10 + (i - 1) * 30, topLeftY + 10, 0, 1.5, 1.5
            else
              .draw images.heartFull, topLeftX + 10 + (i - 1) * 30, topLeftY + 10, 0, 1.5, 1.5

      --draw iris in transition
      if @gameFlow.state == 'game over'
        with love.graphics
          .setBlendMode 'multiplicative'
          .setColor 255, 255, 255, 255
          .draw @cosmetic.irisIn.canvas, topLeftX, topLeftY
          .setBlendMode 'alpha'
