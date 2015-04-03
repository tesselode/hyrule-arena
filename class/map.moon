export class Map
	new: (@world) =>

	addWall: (x, y, w, h) =>
		Physical @world, x, y, w, h
