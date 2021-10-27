import wollok.game.*

object snakeHead {

	var property next = null
	var property direction = toLeft
	var property position = game.center()
	const timesToWin = 10
	
	method image() = "head_" + direction.toString() + ".png"

	method speed(timesCollided) = (timesToWin - timesCollided) * 80

	method addBodyPart() {
		if (next == null) {
			next = new SnakeBody(prev = self, direction = self.direction())
			game.addVisual(next)
		} 
		else next.addBodyPart()
	}

	method changeDirection(newDir) {
		direction = newDir
	}
	
	method lastPos() = direction.previous(position)

	method changePosition() {
		if ( next != null ) {
			next.changePosition(position)
			next.changeDirection(direction)
		}
		position = direction.next(position)
		if ( self.outOfBoundaries() ) {
			self.gameLost("Out of the board, game lost :(")
		}
	}
	
	method removeLast() {
		if( not self.isLast() and not next.isLast() ) {
			next.removeLast()
		} 
		else if( not self.isLast() ) {
			game.removeVisual(next)
			next.prev(null)
			next = null
		} 
		else {
			self.gameLost("Can't eat the banana without a body")
		}
	}

	method isLast() = next == null
	
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
		} 
		else {
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
	var property direction
	var property position = prev.lastPos()
	
	method image() {
		if( self.isCorner() ) {
			if ( (next.direction() == toUp and direction == toLeft) or (next.direction() == toRight and direction == toDown) ) {
				return "corner1.png"
			}
			else if ( (next.direction() == toDown and direction == toLeft) or (next.direction() == toRight and direction == toUp) ) {
				return "corner2.png"
			}
			else if (  (next.direction() == toDown and direction == toRight) or (next.direction() == toLeft and direction == toUp)  ) {
				return "corner3.png"
			}
			else {
				return "corner4.png"
			}
		}
		else if( self.isLast() ) {
			return "tail_" + direction.toString() + ".png"
		}

		else {
			return "body_" + direction.sentido() + ".png"
		}
	}

	method addBodyPart() {
		if ( next == null ) {
			next = new SnakeBody(prev = self, direction = self.direction())
			game.addVisual(next)
		} 
		else next.addBodyPart()
	}

	method changeDirection(newDir) {
		direction = newDir
	}
	
	method lastPos() = direction.previous(position)

	method changePosition(newPos) {
		if ( next != null ) {
			next.changePosition(position)
			next.changeDirection(direction)
		}
		position = newPos
	}
	
	method removeLast() {
		if( not self.isLast() and not next.isLast() ) {
			next.removeLast()
		} 
		else if( not self.isLast() ){
			game.removeVisual(next)
			next.prev(null)
			next = null
		}
	}
	
	method isLast() = next == null
	
	method isCorner() = next != null and next.direction() != self.direction()

	method collideWithSnakeHead(snake) {
		snake.gameLost("Got trapped, game lost :(")
	}

}


class Direction {
	
	const opposite
	const sentido
	
	method previous(position) = opposite.next(position)
	
	method sentido() = sentido

}

object toUp inherits Direction(opposite = toDown, sentido = "vertical") {

	method next(position) = position.up(1)

}

object toRight inherits Direction(opposite = toLeft, sentido = "horizontal") {

	method next(position) = position.right(1)

}

object toDown inherits Direction(opposite = toUp, sentido = "vertical") {

	method next(position) = position.down(1)

}

object toLeft inherits Direction(opposite = toRight, sentido = "horizontal") {

	method next(position) = position.left(1)

}
