import snake.*
import colliders.*
import wollok.game.*


object gameAdministrator {

	const timesToWin = 10
	var level = 1
	const maxLevel = 2

	method timesToWin() = timesToWin

	method gameWon() {
		game.removeTickEvent("MOVE SNAKE")
		game.say(snakeHead, "YOU WON!! :D")
	}

	method gameLost(msg) {
		game.removeTickEvent("MOVE SNAKE")
		game.say(snakeHead, msg)
	}
	
	method isLevelWon(timesCollided) = timesCollided >= timesToWin
	
	method isGameWon(timesCollided) = self.isLevelWon(timesCollided) and level == maxLevel

	method nextLevel(timesCollided) {
		if(self.isGameWon(timesCollided)) {
			self.gameWon()
		} else {
			level += 1
			self.resetGame()
		}
	}
	
	method resetGame() {
		game.clear()
        apple.timesCollided(0)
        snakeHead.position(game.center())
        snakeHead.next(null)
        wall.setPlaceBottomTop(10, 0)
        wall.setPlaceBottomTop(10, 9)
        wall.setPlaceRightLeft(0, 10)
        wall.setPlaceRightLeft(9, 10)
        apple.addVisual()
        game.addVisual(snakeHead)
        game.onTick(snakeHead.speed(), "MOVE SNAKE", { snakeHead.changePosition() })
        game.onCollideDo(snakeHead, { obj => obj.collideWithSnakeHead(snakeHead) })
        game.schedule(10 * 1000, { banana.addVisual() })
        game.schedule(10 * 500, { 
            const stone = new Obstacle()
            stone.schedule()
        })
        keyboard.up().onPressDo{ snakeHead.changeDirection(toUp) }
        keyboard.right().onPressDo{ snakeHead.changeDirection(toRight) }
        keyboard.down().onPressDo{ snakeHead.changeDirection(toDown) }
        keyboard.left().onPressDo{ snakeHead.changeDirection(toLeft) }
        keyboard.s().onPressDo{ game.stop() }	
	}
}
