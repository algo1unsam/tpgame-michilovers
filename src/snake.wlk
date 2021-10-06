import wollok.game.*

object snakeHead {

	var property next = null
//	const property prev = null
	var property image = "player.png"
	var direction = toLeft
	var position = game.center()
	var lastPos = direction.previous(position)
	const timesToWin = 10

	method speed(timesCollided) = (timesToWin - timesCollided) * 80

	method addBodyPart() {
		if (next == null) {
			next = new SnakeBody(prev = self, direction = self.direction())
			game.addVisual(next)
		} else next.addBodyPart()
	}

	method direction() = direction

	method changeDirection(newDir) {
		if (next != null) next.changeDirection(direction)
		direction = newDir
	}

	method position() = position
	
	method lastPos() = lastPos

	method changePosition() {
		lastPos = position // LastPos method o atributo?? 
		position = direction.next(position)
		if (next != null) next.changePosition(lastPos)
		if (self.outOfBoundaries()) {
			self.gameLost("Out of the board, game lost :(")
		}
	}

	method outOfBoundaries() {
		const tooHight = position.y() >= game.height()
		const tooLow = position.y() < 0
		const tooRight = position.x() >= game.width()
		const tooLeft = position.x() < 0
		return tooHight || tooLow || tooLeft || tooRight
	}

	method collideWithFood(timesCollided) {
		if (timesCollided >= timesToWin) {
			game.removeTickEvent("MOVE SNAKE")
			game.say(self, "YOU WON!! :D")
		} else {
			self.addBodyPart()
				// Make it move faster
			game.removeTickEvent("MOVE SNAKE")
			game.onTick(self.speed(timesCollided), "MOVE SNAKE", { self.changePosition()})
		}
	}

	method gameLost(msg) {
		game.removeTickEvent("MOVE SNAKE")
		game.say(self, msg)
	}

}

class SnakeBody {

	var property next = null
	var property prev
	var property image = "spot.png"
	var direction
	var position = prev.lastPos()
	var lastPos = direction.previous(position)

	method addBodyPart() {
		if (next == null) {
			next = new SnakeBody(prev = self, direction = self.direction())
			game.addVisual(next)
		} else next.addBodyPart()
	}

	method direction() = direction

	method changeDirection(newDir) {
		if (next != null) next.changeDirection(direction)
		direction = newDir
	}

	method position() = position
	
	method lastPos() = lastPos

	method changePosition(newPos) {
		lastPos = position
		position = newPos
		if (next != null) next.changePosition(lastPos)
	}

	method collideWithSnakeHead(snake) {
		snake.gameLost("Got trapped, game lost :(")
	}

}

object food {

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

object toUp {

	method next(position) = position.up(1)

	method previous(position) = position.down(1)

}

object toRight {

	method next(position) = position.right(1)

	method previous(position) = position.left(1)

}

object toBottom {

	method next(position) = position.down(1)

	method previous(position) = position.up(1)

}

object toLeft {

	method next(position) = position.left(1)

	method previous(position) = position.right(1)

}

