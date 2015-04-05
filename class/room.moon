random = love.math.random -- convenience

export class Room
	tileSize: 80
	roomDensity: 4
	doorSize: 4

	new: (@world, @x, @y) =>
		w, h = love.graphics.getDimensions!
		@roomWidth  = math.floor w / @tileSize
		@roomHeight = math.floor h / @tileSize
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

		-- outer wall calculations
		wallWidth = @roomWidth/2 - @doorSize/2
		wallHeight = @roomHeight/2 - @doorSize/2
		midX = @roomWidth/2 + @doorSize/2 + 1
		midY = @roomHeight/2 + @doorSize/2 + 1

		-- top left
		@addRoomTile 1, 1, wallWidth, 1
		@addRoomTile 1, 1, 1, wallHeight

		-- top right
		@addRoomTile midX, 1, wallWidth, 1
		@addRoomTile @roomWidth, 1, 1, wallHeight

		-- bottom left
		@addRoomTile 1, @roomHeight, wallWidth, 1
		@addRoomTile 1, midY, 1, wallHeight

		-- bottom right
		@addRoomTile midX, @roomHeight, wallWidth, 1
		@addRoomTile @roomWidth, midY, 1, wallHeight

		@doors =
			left: @

		-- generate some tiles
		tx = random 2, @roomWidth - 1
		ty = random 2, @roomHeight - 1

		for i=1, @roomDensity
			@addRoomTile tx, ty, 1, 1

			-- mirror it across the vertical room center
			@addRoomTile @roomWidth/2 + (@roomWidth/2 - tx) + 1, ty, 1, 1

			-- the math here is done so we never get two tiles in the same position
			-- we're not going to bother checking for mirrored blocks
			tx += random @roomWidth - 2
			ty += random @roomHeight - 2

			if tx > @roomWidth - 1  then tx -= @roomWidth - 2
			if ty > @roomHeight - 1 then ty -= @roomHeight - 2

	addRoomTile: (tx, ty, tw, th) =>
		wx, wy = @getWorldPosition!
		table.insert @tiles, Wall @world,
			wx + util.multiple(tx - 1) * @tileSize,
			wy + util.multiple(ty - 1) * @tileSize,
			util.multiple(tw) * @tileSize,
			util.multiple(th) * @tileSize

	draw: =>
		tile\draw! for tile in *@tiles
