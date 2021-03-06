import wollok.game.*
import gameAdministrator.*
import colliders.*

object snakeHead {

	var property next = null
	var property direction = toLeft
	var property position = game.center()

	method image() = "head_" + direction.nombre() + ".png"

	method speed() = 3 * 100

	method addBodyPart() {
		if (next == null) {
			next = new SnakeBody(prev = self, direction = self.direction())
			game.addVisual(next)
		} else next.addBodyPart()
	}

	method changeDirection(newDir) {
		if (newDir != direction.opposite()) direction = newDir
	}

	method lastPos() = direction.previous(position)

	method changePosition() {
		if (next != null) {
			next.changePosition(position)
			next.changeDirection(direction)
		}
		position = direction.next(position)
		if (self.outOfBoundaries()) {
			gameAdministrator.gameLost("Out of the board, game lost :(")
		}
	}

	method removeLast() {
		if (not self.isLast() and not next.isLast()) {
			next.removeLast()
		} else if (not self.isLast()) {
			game.removeVisual(next)
			next.prev(null)
			next = null
		} else {
			gameAdministrator.gameLost("Can't eat the banana without a body")
		}
	}

	method removeAll() {
		if (next != null) {
			next.removeAll()
			if (game.hasVisual(next)) {
				game.removeVisual(next)
			}
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

	method collideWithFood() {
		if (gameAdministrator.isLevelWon()) {
			gameAdministrator.nextLevel()
		} else {
			self.addBodyPart()
		}
	}

}

class SnakeBody {

	var property next = null
	var property prev
	var property direction
	var property position = prev.lastPos()

	method image() {
		if (self.isCorner()) {
			return direction.cornerWith(next.direction())
		} else if (self.isLast()) {
			return "tail_" + direction.nombre() + ".png"
		} else {
			return "body_" + direction.sentido() + ".png"
		}
	}

	method addBodyPart() {
		if (next == null) {
			next = new SnakeBody(prev = self, direction = self.direction())
			game.addVisual(next)
		} else next.addBodyPart()
	}

	method changeDirection(newDir) {
		if (newDir != direction.opposite()) direction = newDir
	}

	method lastPos() = direction.previous(position)

	method changePosition(newPos) {
		if (next != null) {
			next.changePosition(position)
			next.changeDirection(direction)
		}
		position = newPos
	}

	method removeLast() {
		if (not self.isLast() and not next.isLast()) {
			next.removeLast()
		} else if (not self.isLast()) {
			game.removeVisual(next)
			next.prev(null)
			next = null
		}
	}

	method removeAll() {
		if (next != null) {
			next.removeAll()
			if (game.hasVisual(next)) {
				game.removeVisual(next)
			}
			next = null
		}
	}

	method isLast() = next == null

	method isCorner() = next != null and next.direction() != self.direction()

	method collideWithSnakeHead(snake) {
		gameAdministrator.gameLost("Got trapped, game lost :(")
	}

}

class Direction {

	const opposite
	const sentido
	
	method opposite() = opposite

	method previous(position) = opposite.next(position)

	method sentido() = sentido

}

object toUp inherits Direction(opposite = toDown, sentido = "vertical") {

	const property nombre = "toUp"

	method next(position) = position.up(1)

	method cornerWith(aDirection) = aDirection.cornerWithUp()

	method cornerWithLeft() = "corner1.png"

	method cornerWithRight() = "corner4.png"

}

object toRight inherits Direction(opposite = toLeft, sentido = "horizontal") {

	const property nombre = "toRight"

	method next(position) = position.right(1)

	method cornerWith(aDirection) = aDirection.cornerWithRight()

	method cornerWithUp() = "corner2.png"

	method cornerWithDown() = "corner1.png"

}

object toDown inherits Direction(opposite = toUp, sentido = "vertical") {

	const property nombre = "toDown"

	method next(position) = position.down(1)

	method cornerWith(aDirection) = aDirection.cornerWithDown()

	method cornerWithLeft() = "corner2.png"

	method cornerWithRight() = "corner3.png"

}

object toLeft inherits Direction(opposite = toRight, sentido = "horizontal") {

	const property nombre = "toLeft"

	method next(position) = position.left(1)

	method cornerWith(aDirection) = aDirection.cornerWithLeft()

	method cornerWithUp() = "corner3.png"

	method cornerWithDown() = "corner4.png"

}

