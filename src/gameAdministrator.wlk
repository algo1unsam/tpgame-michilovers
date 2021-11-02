import snake.*
import colliders.*
import wollok.game.*


object gameAdministrator {

	const timesToWin = 10

	method timesToWin() = timesToWin

	method gameWon() {
		game.removeTickEvent("MOVE SNAKE")
		game.say(snakeHead, "YOU WON!! :D")
	}

	method gameLost(msg) {
		game.removeTickEvent("MOVE SNAKE")
		game.say(snakeHead, msg)
	}
	
	method isGameWon(timesCollided) = timesCollided >= self.timesToWin()

}
