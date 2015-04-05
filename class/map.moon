export class Map
	new: (@world) =>
		@player = Player @world, 400, 300
		@rooms = {}
		@currentRoom = nil

		@addRoom 0, 0

	update: (dt) =>
		room = @currentRoom
		rx, ry, rw, rh = room\getWorldRect!

		with @player
			{:x, :y} = \getCenter!
			_, _, width, height = .world\getRect @player
			if x + width < rx and .velocity.x < 0
				@exploreTo room.x - 1, room.y
			elseif x >= rx + rw and .velocity.x > 0
				@exploreTo room.x + 1, room.y
			elseif y + height < ry and .velocity.y < 0
				@exploreTo room.x, room.y - 1
			elseif y >= ry + rh and .velocity.y > 0
				@exploreTo room.x, room.y + 1

	addEnemy: (enemyType, x, y) =>
		enemyType @world, self, x, y

	addRoom: (x, y) =>
		newRoom = Room @world, x, y

		@rooms[x] or= {}
		@rooms[x][y] = newRoom
		@currentRoom or= newRoom
		newRoom

	exploreTo: (x, y) =>
		@currentRoom = @getRoomAt(x, y) or @addRoom x, y

	getRoomAt: (x, y) => @rooms[x] and @rooms[x][y] or nil

	draw: =>
		-- here we'd probably also draw the shadow of everything else as well
		@player\drawShadow!

		for i,row in pairs @rooms
			for j,room in pairs row
				room\draw!

		@player\draw!
