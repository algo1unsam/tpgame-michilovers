import wollok.game.*

class Snake {
	var property next = null
	var property prev = null
	var property direction
	var property position
	
	method image()
	
	method addBodyPart() {
		if (next == null) {
			next = new SnakeBody(prev = self, direction = self.direction(), position = self.lastPos())
			game.addVisual(next)
		} 
		else next.addBodyPart()
	}
	
	method changePosition(newPos) {
		if ( next != null ) {
			next.changePosition(position)
			next.changeDirection(direction)
		}	
	}
	
	method lastPos() = direction.previous(position)
	
	method changeDirection(newDir) {
		direction = newDir
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
	
}

object snakeHead inherits Snake(direction = toLeft, position = game.center()) {
	const timesToWin = 20
	
	override method image() = "head_" + direction.toString() + ".png"
	
	override method changePosition(newPos) {
		super(newPos)
		position = direction.next(position)
		if ( self.outOfBoundaries() ) {
			self.gameLost("Out of the board, game lost :(")
		}
	}
	
	override method removeLast() {
		if(self.isLast()) {
			self.gameLost("Can't eat the banana without a body")
		}
		super()
	}

	method speed(timesCollided) = (timesToWin - timesCollided) * 80

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
			game.onTick(self.speed(timesCollided), "MOVE SNAKE", { self.changePosition(null)})
		}
	}

	method gameLost(msg) {
		game.removeTickEvent("MOVE SNAKE")
		game.say(self, msg)
	}

}

class SnakeBody inherits Snake{

	override method image() {
		if( self.isCorner() ) {
			return direction.cornerWith(next.direction())
		}
		else if( self.isLast() ) {
			return "tail_" + direction.toString() + ".png"
		}

		else {
			return "body_" + direction.sentido() + ".png"
		}
	}

	override method changePosition(newPos) {
		super(newPos)
		position = newPos
	}
	
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
	
	method cornerWith(aDirection) = aDirection.cornerWithUp()
	
	method cornerWithLeft() = "corner1.png"
	
	method cornerWithRight() = "corner4.png"

}

object toRight inherits Direction(opposite = toLeft, sentido = "horizontal") {

	method next(position) = position.right(1)
	
	method cornerWith(aDirection) = aDirection.cornerWithRight()
	
	method cornerWithUp() = "corner2.png"
	
	method cornerWithDown() = "corner1.png"

}

object toDown inherits Direction(opposite = toUp, sentido = "vertical") {

	method next(position) = position.down(1)
	
	method cornerWith(aDirection) = aDirection.cornerWithDown()
	
	method cornerWithLeft() = "corner2.png"
	
	method cornerWithRight() = "corner3.png"

}

object toLeft inherits Direction(opposite = toRight, sentido = "horizontal") {

	method next(position) = position.left(1)

	method cornerWith(aDirection) = aDirection.cornerWithLeft()
	
	method cornerWithUp() = "corner3.png"
	
	method cornerWithDown() = "corner4.png"

}
