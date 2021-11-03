import snake.*
import colliders.*
import wollok.game.*


object gameAdministrator {

	const timesToWin = 10
	var level = 1
	const maxLevel = 3

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
			self.addWalls()
		}
	}
	
	method resetGame() {
		game.clear()
        apple.timesCollided(0)
        snakeHead.position(game.center())
        snakeHead.next(null)
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
	
	method addWalls() {
		wall.setPlaceBottomTop(game.width(), 0)
        wall.setPlaceBottomTop(game.width(), game.height() - 1)
        wall.setPlaceRightLeft(0, game.width())
        wall.setPlaceRightLeft(game.height() - 1, game.width())
         
	   	if(level == 3) {
			wall.setPlaceBottomTop(game.width() - 1, 1)
	        wall.setPlaceBottomTop(game.width() - 1, game.height() - 2)
	        wall.setPlaceRightLeft(1, game.width() - 1)
	        wall.setPlaceRightLeft(game.height() - 2, game.width() - 1)	   		
	   	}
	}
}
