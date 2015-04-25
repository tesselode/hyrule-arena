export class Game extends Common
  new: =>
    super!

    -- game world
    @world = bump.newWorld!
    @map = Map self

    -- cameras
    @camera = {}
    with @camera
      .main = camera.new! -- for resolution independence
      .main\zoomTo love.graphics.getHeight! / (BASE_HEIGHT - TILE_SIZE / 2)
      .world = camera.new!
      --initial camera placement
      room = @map.currentRoom
      x, y = room\getWorldCenter!
      .world\lookAt x, y


    -- game flow
    @gameFlow = {
      state: 'title'
      score: 0
      multiplier: 1
    }

    -- menus
    @menu =
      title: TitleMenu self
      gameOver: GameOverMenu self

    -- cosmetic stuff
    @cosmetic = {
      hud: HUD self
      playerSpawnAnimation: PlayerSpawnAnimation self
      irisInAnimation: IrisInAnimation self
    }

  runStartingAnimation: =>
    @gameFlow.state == 'startingAnimation'
    @cosmetic.hud\flyDown!
    @cosmetic.playerSpawnAnimation\start!
    @menu.title\flyUp!

  startGame: =>
    with @gameFlow
      .state = 'gameplay'
    @player = Player self, BASE_WIDTH / 2 - TILE_SIZE / 2, BASE_HEIGHT / 2 - TILE_SIZE / 2
    @controller = Controller @player, love.joystick.getJoysticks![1]

  update: (dt) =>
    super dt

    -- get the current room
    room = @map.currentRoom
    rx, ry, rw, rh = room\getWorldRect!

    if @gameFlow.state == 'gameplay'
      -- update the map
      @map\update dt

      @controller\update dt

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

      -- trigger game over
      if @player.health <= 0
        @player.ghostingVisible = true
        @gameFlow.state = 'game over'
        @cosmetic.irisInAnimation\closeIn!
        @menu.gameOver\flyUp!

    -- update camera
    x, y = room\getWorldCenter!
    @camera.world\lookAt util.interpolate(@camera.world.x, x, dt * 7), util.interpolate(@camera.world.y, y, dt * 7)

    -- update cosmetic stuff
    @menu.title\update dt
    @menu.gameOver\update dt
    @cosmetic.hud\update dt
    @cosmetic.playerSpawnAnimation\update dt
    @cosmetic.irisInAnimation\update dt

  keypressed: (key) =>
    if key == 'return'
      -- start the game
      if @gameFlow.state == 'title'
        @runStartingAnimation!

      -- reset game
      if @gameFlow.state == 'game over'
        -- delete all world objects
        for item in *@world\getItems!
          @world\remove item

        with @gameFlow
          -- switch to title screen
          .state = 'title'
          -- reset score and stuff
          .score = 0
          .multiplier = 1

        -- reset map
        @map = Map self

        -- animations
        @menu.title\flyDown!
        @menu.gameOver\flyDown!
        @cosmetic.hud\flyUp!
        @cosmetic.irisInAnimation\openUp!

      if @gameFlow.state == 'gameplay'
        gamestate.push Paused!

    -- controls
    if @gameFlow.state == 'gameplay'
      @controller\keypressed key

  keyreleased: (key) =>
    if @gameFlow.state == 'gameplay'
      @controller\keyreleased key

  gamepadpressed: (gamepad, button) =>
    if @gameFlow.state == 'title'
      if button == 'a' or button == 'start'
        @runStartingAnimation!

    if @gameFlow.state == 'gameplay'
      if button == 'start'
        gamestate.push Paused!
      else
        @controller\gamepadpressed gamepad, button

  gamepadreleased: (...) =>
    if @gameFlow.state == 'gameplay'
      @controller\gamepadreleased ...

  gamepadaxis: (...) =>
    if @gameFlow.state == 'gameplay'
      @controller\gamepadaxis ...

  draw: =>
    -- render iris in transition
    @cosmetic.irisInAnimation\render!

    @camera.main\draw ->
      @camera.world\draw ->
        -- draw room floors
        for _,row in pairs @map.rooms
          for _,room in pairs row
            room\drawFloor!

        -- draw all instances
        objects = @world\getItems!
        table.sort objects, (a, b) -> return a.depth < b.depth -- sort objects by drawing order

        for object in *objects
          object\drawShadow!

        for object in *objects
          object\draw!

        -- draw player spawn animation
        @cosmetic.playerSpawnAnimation\draw!

      -- gui stuff
      topLeftX, topLeftY = @camera.main\worldCoords 0, 0
      @cosmetic.irisInAnimation\draw topLeftX, topLeftY
      @cosmetic.hud\draw topLeftX, topLeftY
      @menu.title\draw topLeftX, topLeftY
      @menu.gameOver\draw topLeftX, topLeftY
