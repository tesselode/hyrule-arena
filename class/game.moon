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

    --menus
    @menu =
      title: TitleMenu self
      gameOver: GameOverMenu self

    --cosmetic stuff
    @cosmetic = {
      playerSpawnAnimation: PlayerSpawnAnimation self
      irisInAnimation: IrisInAnimation self
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

      --trigger game over
      if @player.health <= 0
        @gameFlow.state = 'game over'
        @cosmetic.irisInAnimation\closeIn!
        @menu.gameOver\flyUp!

    --update camera
    x, y = room\getWorldCenter!
    @camera.world\lookAt util.interpolate(@camera.world.x, x, dt * 7), util.interpolate(@camera.world.y, y, dt * 7)

    --update cosmetic stuff
    @menu.title\update dt
    @menu.gameOver\update dt
    @cosmetic.playerSpawnAnimation\update dt
    @cosmetic.irisInAnimation\update dt

  keypressed: (key) =>
    if key == 'return'
      --start the game
      if @gameFlow.state == 'title'
        @gameFlow.state == 'startingAnimation'
        @cosmetic.playerSpawnAnimation\start!
        @menu.title\flyUp!

      --reset game
      if @gameFlow.state == 'game over'
        --delete all world objects
        for item in *@world\getItems!
          @world\remove item
        --reset map
        @map = Map self
        --switch to title screen
        @gameFlow.state = 'title'
        --animations
        @menu.title\flyDown!
        @menu.gameOver\flyDown!
        @cosmetic.irisInAnimation\openUp!


    --controls
    if @gameFlow.state == 'gameplay'
      if key == 'x'
        @player\attack!

      --for testing
      if key == 'f1'
        @player.health = 0

  draw: =>
    --render iris in transition
    @cosmetic.irisInAnimation\render!

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

      --draw iris in animation
      @cosmetic.irisInAnimation\draw topLeftX, topLeftY

      --draw menus
      @menu.title\draw topLeftX, topLeftY
      @menu.gameOver\draw topLeftX, topLeftY
