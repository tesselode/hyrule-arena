export class Map
	new: (@world) =>

	addWall: (x, y, w, h) =>
		wall = Wall @world, x, y, w, h
