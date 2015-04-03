export class Map
	new: (@world) =>
		@player = Player @world, 400, 300

	addWall: (x, y, w, h) =>
		Wall @world, x, y, w, h

	addEnemy: (x, y) =>
		Enemy @world, self, x, y
