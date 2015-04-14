export class Map extends Common
	new: (@state) =>
		super!

		@world = @state.world

		@rooms = {}
		@currentLevel = 1
		@currentRoom = @addRoom 0, 0, false

	update: (dt) =>
		super dt

		with @currentRoom
			if \isCompleted!
				\openDoors!
			else
				if \withinWalls @state.player
					\closeDoors!
				-- else
				-- 	\openDoors!

	addRoom: (x, y, genRoom) =>
		newRoom = Room @state, x, y, @currentLevel, genRoom
		@rooms[x] or= {}
		@rooms[x][y] = newRoom
		@currentLevel += 1 -- increase level by one
		newRoom

	exploreTo: (x, y) =>
		@currentRoom = @getRoomAt(x, y) or @addRoom x, y

	getRoomAt: (x, y) => @rooms[x] and @rooms[x][y] or nil
