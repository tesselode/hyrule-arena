export class Map
	new: (@world) =>
		@player = Player @world, 400, 300
		@rooms = {
			Room @world, 0, 0
			Room @world, 1, 0
			Room @world, 0, 1
			Room @world, 1, 1
		}

	addWall: (x, y, w, h) =>
		Wall @world, x, y, w, h

	addEnemy: (enemyType, x, y) =>
		enemyType @world, self, x, y
