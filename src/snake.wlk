import wollok.game.*

object snakeHead {

	var property next = null
	var property image = "player.png"
	var direction = toLeft
	var position = game.center()
	const timesToWin = 10
	
	method image() = "head_" + direction.toString() + ".png" //	

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
	
	method lastPos() = direction.previous(position)

	method changePosition() {
		if (next != null) next.changePosition(position)
		position = direction.next(position)
		if (self.outOfBoundaries()) {
			self.gameLost("Out of the board, game lost :(")
		}
	}
	
	method removeLast() {
		if(not self.isLast() and not next.isLast()) {
			next.removeLast()
		} else if(not self.isLast()){
			game.removeVisual(next)
			next.prev(null)
			next = null
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
		else if ( direction == toLeft or direction == toRight ) {
			return "body_horizontal.png"
		}
		else {
			return "body_vertical.png"
		}
	}

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
	
	method lastPos() = direction.previous(position)

	method changePosition(newPos) {
		if (next != null) next.changePosition(position)
		position = newPos
	}
	
	method removeLast() {
		if(not self.isLast() and not next.isLast()) {
			next.removeLast()
		} else if(not self.isLast()){
			game.removeVisual(next)
			next.prev(null)
			next = null
		}
	}
	
	method isLast() = next == null
	
	method isCorner() { // veo si es una esquina
		if (next != null) {
			return next.direction() != self.direction() // para que sea una esquina, la tail posterior debe tener una dirección diferente a la actual
		}
		else {
			return false
		}
	}

	method collideWithSnakeHead(snake) {
		snake.gameLost("Got trapped, game lost :(")
	}

}

// Hacer que todas las posiciones sepan contestar su direccion contraria
// por ejemplo el opuesto de Up es Bottom, y el de Right es Left
// Aprevechar eso para tener una unica definicion del metodo previous

class Direction {
	
	const opposite
	
	method previous(position) = opposite.next(position)

}

object toUp inherits Direction(opposite = toDown) {

	method next(position) = position.up(1)

}

object toRight inherits Direction(opposite = toLeft) {

	method next(position) = position.right(1)

}

object toDown inherits Direction(opposite = toUp) { // lo cambio a down porque es el opuesto de up, bottom es el opuesto de top jaja

	method next(position) = position.down(1)

}

object toLeft inherits Direction(opposite = toRight) {

	method next(position) = position.left(1)

}
