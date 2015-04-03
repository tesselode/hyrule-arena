export class Map
	new: (@world) =>
		@player = Player @world, 400, 300

	addWall: (x, y, w, h) =>
		Wall @world, x, y, w, h

	addEnemy: (enemyType, x, y) =>
		enemyType @world, self, x, y
