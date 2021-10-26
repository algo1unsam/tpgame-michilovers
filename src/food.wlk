import snake.*
import wollok.game.*

object apple {

	var property timesCollided = 0
	var property image = "manzana.png"
	var property position = self.randomPos()

	method randomPos() = game.at(0.randomUpTo(game.width()), 0.randomUpTo(game.height()))

	method collideWithSnakeHead(snake) {
		timesCollided += 1
		snake.collideWithFood(timesCollided)
		position = self.randomPos()
	}

}

object banana {

	var property image = "banana.png"
	var property position = self.randomPos()

	method randomPos() = game.at(0.randomUpTo(game.width()), 0.randomUpTo(game.height()))
	
	method collideWithSnakeHead(snake) {
		snake.removeLast()
	}
	
}