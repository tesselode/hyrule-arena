export class Map
	new: (@world) =>

	addWall: (x, y, w, h) =>
		wall = Physical @world, x, y, w, h
		wall.id = 'wall'
