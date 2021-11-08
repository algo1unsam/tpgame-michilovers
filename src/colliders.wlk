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

object orange inherits Colliders {
	
	var property image = "orange.png"
	
	method collideWithSnakeHead(snake) {
		snake.removeAll()
		game.removeVisual(self)
	}	
	
}

class Obstacle inherits Colliders {
	
	var property image = "stone.png"
	
	method collideWithSnakeHead(snake) {
		gameAdministrator.gameLost("LOSE, You crashed :(")
	}
	
	method schedule() {
		self.addVisual()
		game.schedule(5 * 1000, { (new Obstacle()).schedule() })
	} 
	
}

object wall {
	
	const positions = []
	
	method setPlaceBottomTop(a, b) {
		// a = es la coordenada que va recorriendo a b
		// b = es la coordenada fija
		a.times({ i => positions.add( game.at(i - 1, b) ) }) // lleno la lista con las posiciones de la fila de piedras (pared)
		self.fillWithStones() // agregado las piedras a la pared
		positions.clear() // luego de poner la pared, vacío las posiciones para llenarlas nuevamente en otra pared 
	}
	
	method setPlaceRightLeft(a, b) {
		// a = es la coordenada que va recorriendo a b
		// b = es la coordenada fija
		b.times({ i => positions.add( game.at(a, i - 1) ) })
		self.fillWithStones() // agregado las piedras a la pared
		positions.clear() 
	}
	
	method fillWithStones() {
		const stones = []
		const wallSize = positions.size()
		wallSize.times({ i => stones.add( new Obstacle() ) }) // lleno una lista de piedras
		wallSize.times({ i => stones.get(i - 1).position( positions.get(i - 1) ) }) // a cada piedra le asigno una posición
		stones.forEach({ stone => game.addVisual(stone) }) // agrego las piedras al mapa
	}
	
}