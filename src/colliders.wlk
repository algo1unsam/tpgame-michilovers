import snake.*
import wollok.game.*

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

	var property timesCollided = 0
	var property image = "manzana.png"

	method collideWithSnakeHead(snake) {
		
		timesCollided += 1
		snake.collideWithFood(timesCollided)
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

class Obstacle inherits Colliders {
	
	var property image = "stone.png"
	
	method collideWithSnakeHead(snake) {
		
		snake.gameLost("You crashed :(")
		
	}
	
	method schedule(thing) {
		
		thing.addVisual()
		game.schedule(10 * 500, { 
			const stone = new Obstacle()
			stone.schedule(stone)
		})
		
	} 
	
}