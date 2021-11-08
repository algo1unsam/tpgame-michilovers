import snake.*
import colliders.*
import wollok.game.*

//Importante, el administrador es un objeto bien conocido y también conoce todos los objetos.

object gameAdministrator {

	const timesToWin = 10
	var level = 1
	const maxLevel = 3
	var property timesCollided = 0
	
	method snakeAteApple(){
		timesCollided += 1
		if( timesCollided == timesToWin.div(2) ){
			orange.addVisual()
		}
	}
	
	method timesToWin() = timesToWin

	method gameWon() {
		game.removeTickEvent("MOVE SNAKE")
		game.say(snakeHead, "YOU WON!! :D")
	}

	method gameLost(msg) {
		game.removeTickEvent("MOVE SNAKE")
		game.say(snakeHead, msg)
		
		if(game.hasVisual(apple)){
			game.removeVisual(apple)
		}
		
		if(game.hasVisual(banana)){
			game.removeVisual(banana)
		}
		
		if(game.hasVisual(orange)){
			game.removeVisual(orange)
		}
		
	}
	
	method isLevelWon() = timesCollided >= timesToWin
	
	method isGameWon() = self.isLevelWon() and level == maxLevel

	method nextLevel() {
		if( self.isGameWon() ) {
			self.gameWon()
		} else {
			level += 1
			self.resetGame()
			self.addWalls()
		}
	}
	
	method resetGame() {
		game.clear()
        timesCollided = 0
        snakeHead.position(game.center())
        snakeHead.removeAll()
		apple.addVisual()
        game.addVisual(snakeHead)
        game.onTick(snakeHead.speed(), "MOVE SNAKE", { snakeHead.changePosition() })
        game.onCollideDo(snakeHead, { obj => obj.collideWithSnakeHead(snakeHead) })
        game.schedule(10 * 1000, { banana.addVisual() })
    	game.schedule(5 * 1000, { (new Obstacle()).schedule() })
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
