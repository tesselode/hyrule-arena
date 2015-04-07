export class Map
	new: =>
		@world = bump.newWorld!
		@player = Player @world, 400, 300
		@rooms = {}
		@currentRoom = @addRoom 0, 0
		Octorok @world, 300, 300

	update: (dt) =>
		--update all instances
		for item in *@world\getItems!
			if item.delete
				item\onDelete!
				@world\remove item
			else
				item\update dt

		--keep track of which room the player is in
		room = @currentRoom
		rx, ry, rw, rh = room\getWorldRect!

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

	addRoom: (x, y) =>
		newRoom = Room @world, x, y
		@rooms[x] or= {}
		@rooms[x][y] = newRoom
		newRoom

	exploreTo: (x, y) =>
		@currentRoom = @getRoomAt(x, y) or @addRoom x, y

	getRoomAt: (x, y) => @rooms[x] and @rooms[x][y] or nil

	draw: =>
		--draw all instances
		objects = @world\getItems!
		table.sort objects, (a, b) -> return a.depth < b.depth --sort objects by drawing order
		for object in *objects
			object\draw!
