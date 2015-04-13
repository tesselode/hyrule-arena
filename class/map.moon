export class Map extends Common
	new: (@state) =>
		super!

		@world = @state.world

		@rooms = {}
		@currentLevel = 1
		@currentRoom = @addRoom 0, 0, false

		--game flow
		@gameStarted = false
		@gameOver = false
		@animationStarted = false
		@playerSpawnAnimation = PlayerSpawnAnimation self

	update: (dt) =>
		super dt

		-- keep track of which room the player is in
		--if @gameStarted
		--	with @player
		--		{:x, :y} = \getCenter!
		--		_, _, width, height = .world\getRect @player
		--		if x < rx and .velocity.x < 0
		--			@exploreTo room.x - 1, room.y
		--		elseif x >= rx + rw and .velocity.x > 0
		--			@exploreTo room.x + 1, room.y
		--		elseif y < ry and .velocity.y < 0
		--			@exploreTo room.x, room.y - 1
		--		elseif y >= ry + rh and .velocity.y > 0
		--			@exploreTo room.x, room.y + 1

		with @currentRoom
			if \isCompleted!
				\openDoors!
			else
				if \withinWalls @state.player
					\closeDoors!
				-- else
				-- 	\openDoors!

		--game start animation
		--if (not @gameStarted) and (not @animationStarted) and love.keyboard.isDown 'return'
		--	@animationStarted = true
		--	@playerSpawnAnimation\start!

		--game over
		--if @gameStarted and (not @gameOver) and @player.health <= 0
		--	@gameOver = true
		--	@tween\to(@state, 1, {irisInRadius: 100})

		--update cosmetic things
		--@playerSpawnAnimation\update dt

	addRoom: (x, y, genRoom) =>
		newRoom = Room @world, x, y, @currentLevel, genRoom
		@rooms[x] or= {}
		@rooms[x][y] = newRoom
		@currentLevel += 1 -- increase level by one
		newRoom

	exploreTo: (x, y) =>
		@currentRoom = @getRoomAt(x, y) or @addRoom x, y

	getRoomAt: (x, y) => @rooms[x] and @rooms[x][y] or nil

	draw: =>
		--draw cosmetic things
		--@playerSpawnAnimation\draw!
