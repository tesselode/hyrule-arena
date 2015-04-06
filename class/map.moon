export class Map
	new: (@world) =>
		@player = Player @world, 400, 300
		@rooms = {}
		@currentRoom = @addRoom 0, 0
		@enemies = {}

	update: (dt) =>
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

	addEnemy: (enemyType, x, y) =>
		table.insert @enemies, enemyType @world, self, x, y

	addRoom: (x, y) =>
		newRoom = Room @world, x, y
		@rooms[x] or= {}
		@rooms[x][y] = newRoom
		newRoom

	exploreTo: (x, y) =>
		@currentRoom = @getRoomAt(x, y) or @addRoom x, y

	getRoomAt: (x, y) => @rooms[x] and @rooms[x][y] or nil

	draw: =>
		-- here we'd probably also draw the shadow of everything else as well
		@player\drawShadow!

		for enemy in *@enemies do
			enemy\drawShadow!

		for i,row in pairs @rooms
			for j,room in pairs row
				room\draw!

		@player\draw!

		for enemy in *@enemies do
			enemy\draw!
