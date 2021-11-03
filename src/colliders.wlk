import snake.*
import wollok.game.*
import gameAdministrator.*

class Colliders {
	
	var property position = self.randomPos()
	
	method addVisual() {
		game.addVisual(self)
		self.getUniquePos() // cada vez que spawneen, debe verificarse que no se superponga con otro objeto
	}

	method randomPos() = game.at(0.randomUpTo(game.width()), 0.randomUpTo(game.height()))
	
	method getUniquePos() {
		if( not self.emptyPlace() ) { // si no es un lugar vacío, entonces allí hay un objeto
			position = self.randomPos() // elijo otra posición
			self.getUniquePos() // verifico nuevamente que sea un lugar vacío
		}
	}
	
	method emptyPlace() = game.colliders(self).isEmpty()
	
}

object apple inherits Colliders {

	var property image = "manzana.png"

	method collideWithSnakeHead(snake) {
		
		gameAdministrator.snakeAteApple()
		snake.collideWithFood()
		position = self.randomPos()
		self.getUniquePos()
				
	}

}

object banana inherits Colliders {

	var property image = "banana.png"
	
	method collideWithSnakeHead(snake) {
		
		snake.removeLast()
		game.removeVisual(self)
		position = self.randomPos()		
		game.schedule(10 * 1000, { self.addVisual() })
		
	}
	
}

class Orange inherits Colliders {
	
}

class Obstacle inherits Colliders {
	
	var property image = "stone.png"
	
	method collideWithSnakeHead(snake) {
		
		gameAdministrator.gameLost("You crashed :(")
		
	}
	
	method schedule() {
		
		self.addVisual()
		game.schedule(10 * 500, { 
			const stone = new Obstacle()
			stone.schedule()
		})
		
	} 
	
}

object wall {
	
	const positions = []
	
	method setPlaceBottomTop(a, b) {
		// a = es la coordenada que va recorriendo a b
		// b = es la coordenada fija
		a.times({ i => positions.add( game.at(i - 1, b) ) })
		self.fillWithStones()
		positions.clear()
	}
	
	method setPlaceRightLeft(a, b) {
		// a = es la coordenada que va recorriendo a b
		// b = es la coordenada fija
		b.times({ i => positions.add( game.at(a, i - 1) ) })
		self.fillWithStones()
		positions.clear()
	}
	
	method fillWithStones() {
		const stones = []
		const wallSize = positions.size()
		wallSize.times({ i => stones.add( new Obstacle() ) })
		wallSize.times({ i => stones.get(i - 1).position(positions.get(i - 1)) })
		stones.forEach({ stone => game.addVisual(stone) })	
	}
	
}