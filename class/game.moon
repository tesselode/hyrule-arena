export class Game extends Common
  new: =>
    super!

    --game world
    @world = bump.newWorld!
    @map = Map @world

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
      irisIn: {
        canvas: love.graphics.newCanvas 1024, 576
        radius: 2000
      }
    }

  startGame: =>
    @gameFlow.state = 'playing'
    @player = Player @world, 512 - 16, 288 - 16

  update: (dt) =>
    super dt

    --get the current room
    room = @map.currentRoom
    rx, ry, rw, rh = room\getWorldRect!

    if (not @gameOver)
			-- update all instances in the active room
      items = @world\queryRect room\getWorldRect!
      for item in *items
        item\update dt

			-- delete instances
      for item in *items
        if item.delete
          item\onDelete!
          @world\remove item

    -- keep track of which room the player is in
    if @gameFlow.state == 'playing'
    	with @player
    		{:x, :y} = \getCenter!
    		_, _, width, height = .world\getRect @player
    		if x < rx and .velocity.x < 0
    			@map\exploreTo room.x - 1, room.y
    		elseif x >= rx + rw and .velocity.x > 0
    			@map\exploreTo room.x + 1, room.y
    		elseif y < ry and .velocity.y < 0
    			@map\exploreTo room.x, room.y - 1
    		elseif y >= ry + rh and .velocity.y > 0
    			@map\exploreTo room.x, room.y + 1

    --update camera
    x, y = room\getWorldCenter!
    @camera.world\lookAt util.interpolate(@camera.world.x, x, dt * 7), util.interpolate(@camera.world.y, y, dt * 7)

  keypressed: (key) =>
    if key == 'return'
      @startGame!
    --controls
    --if key == 'x'
    --  @map.player\attack!

  draw: =>
    --draw all instances
    @camera.main\draw ->
      @camera.world\draw ->
        objects = @world\getItems!
        table.sort objects, (a, b) -> return a.depth < b.depth --sort objects by drawing order

        for object in *objects
          object\drawShadow!

        for object in *objects
          object\draw!

    --render iris in transition
    --if @map.gameStarted
    --  with love.graphics
    --    @irisInCanvas\clear 0, 0, 0, 255
    --    @irisInCanvas\renderTo(->
    --      cameraX, cameraY = @camera.map\pos!
    --      playerX, playerY = @map.player\getCenter!.x, @map.player\getCenter!.y
    --      .setColor 255, 255, 255, 255
    --      .circle 'fill', playerX - cameraX + 512, playerY - cameraY + 288, @irisInRadius)


    --@camera.main\draw ->
      --draw the game world
      --@camera.map\draw(->
      --  @map\draw!)

      --gui stuff
      --topLeftX, topLeftY = @camera.main\worldCoords 0, 0
      --if @map.gameStarted
      --  for i = 1, @map.player.maxHealth
      --    with love.graphics
      --      .setColor 255, 255, 255, 255
      --      if i > @map.player.health
      --        .draw images.heartEmpty, topLeftX + 10 + (i - 1) * 30, topLeftY + 10, 0, 1.5, 1.5
      --      else
      --        .draw images.heartFull, topLeftX + 10 + (i - 1) * 30, topLeftY + 10, 0, 1.5, 1.5

      --render iris in transition
      --if @map.gameStarted
      --  with love.graphics
      --    .setBlendMode 'multiplicative'
      --    .setColor 255, 255, 255, 255
      --    .draw @irisInCanvas, topLeftX, topLeftY
      --    .setBlendMode 'alpha'
