export class Room
	random = love.math.random -- convenience

	roomWidth: 20
	roomHeight: 11
	tileSize: 64
	roomDensity: 6

	new: (@world, @x, @y) =>
		@generateRoom!

	getWorldSize: =>
		@roomWidth * @tileSize, @roomHeight * @tileSize

	getWorldPosition: =>
		w, h = @getWorldSize!
		@x * w, @y * h

	getWorldRect: =>
		x, y = @getWorldPosition!
		w, h = @getWorldSize!
		x, y, w, h

	getWorldCenter: =>
		x, y, w, h = @getWorldRect!
		x + w/2, y + h/2

	generateRoom: =>
		@tiles = {}

		-- outer walls
		@addRoomTile 1, 1, 1, @roomHeight          -- left
		@addRoomTile 1, 1, @roomWidth, 1           -- top
		@addRoomTile @roomWidth, 1, 1, @roomHeight -- right
		@addRoomTile 1, @roomHeight, @roomWidth, 1 -- bottom

		-- generate some tiles
		tx = random 2, @roomWidth - 1
		ty = random 2, @roomHeight - 1

		for i=1, @roomDensity
			@addRoomTile tx, ty, 1, 1

			-- mirror it across the vertical room center
			@addRoomTile @roomWidth/2 + (@roomWidth/2 - tx) + 1, ty, 1, 1

			-- the math here is done so we never get two tiles in the same position
			-- we're not going to bother doing it so it checks for mirrored blocks
			tx += random @roomWidth - 2
			ty += random @roomHeight - 2

			if tx > @roomWidth - 1  then tx -= @roomWidth - 2
			if ty > @roomHeight - 1 then ty -= @roomHeight - 2

	addRoomTile: (tx, ty, tw, th) =>
		wx, wy = @getWorldPosition!
		table.insert @tiles, Wall @world,
			wx + (tx - 1) * @tileSize,
			wy + (ty - 1) * @tileSize,
			tw * @tileSize,
			th * @tileSize

	draw: =>
		tile\draw! for tile in *@tiles
