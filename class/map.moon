export class Map
	new: =>
		@world = bump.newWorld!
		@player = Player @world, 400, 300
		@rooms = {}
		@currentLevel = 1
		@currentRoom = @addRoom 0, 0, false

	update: (dt) =>
		room = @currentRoom
		rx, ry, rw, rh = room\getWorldRect!

		-- update all instances in the active room
		items = @world\queryRect room\getWorldRect!

		for item in *items
			item\update dt

		-- delete after all is said and done, so we don't update in the middle of removing objects
		-- and get nasty holes in the table
		for item in *items
			if item.delete
				item\onDelete!
				@world\remove item

		-- keep track of which room the player is in
		with @player
			{:x, :y} = \getCenter!
			_, _, width, height = .world\getRect @player
			if x < rx and .velocity.x < 0
				@exploreTo room.x - 1, room.y
			elseif x >= rx + rw and .velocity.x > 0
				@exploreTo room.x + 1, room.y
			elseif y < ry and .velocity.y < 0
				@exploreTo room.x, room.y - 1
			elseif y >= ry + rh and .velocity.y > 0
				@exploreTo room.x, room.y + 1

		with room
			if \isCompleted!
				\openDoors!
			else
				if \withinWalls @player
					\closeDoors!
				-- else
				-- 	\openDoors!


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
		--draw all instances
		objects = @world\getItems!
		table.sort objects, (a, b) -> return a.depth < b.depth --sort objects by drawing order

		for object in *objects
			object\drawShadow!

		for object in *objects
			object\draw!
