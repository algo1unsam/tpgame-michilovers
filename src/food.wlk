import snake.*
import wollok.game.*

class Food {
	
	var property position = self.randomPos()

	method randomPos() = game.at(0.randomUpTo(game.width()), 0.randomUpTo(game.height()))
	
}

object apple inherits Food {

	var property timesCollided = 0
	var property image = "manzana.png"

	method collideWithSnakeHead(snake) {
		timesCollided += 1
		snake.collideWithFood(timesCollided)
		position = self.randomPos()
	}

}

object banana inherits Food {

	var property image = "banana.png"
	
	method collideWithSnakeHead(snake) {
		snake.removeLast()
		game.removeVisual(self)
		game.schedule(10 * 1000, { game.addVisual(self) })
		position = self.randomPos()
	}
	
}