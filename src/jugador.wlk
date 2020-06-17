import wollok.game.*

object jugador {
	var property position
	 
	var gameOver = false 
	var enCutscene = false
	var cuarto = null
	var puertaElegida = null

	method image() = if (enCutscene) "invisible.png" else "you.png"
	method image() = if (self.enIntro() or self.enCutscene()) "invisible.png" else "you.png"
	
	method esGameOver() = gameOver
	method toggleGameOver() { gameOver = not(gameOver) }
	
	method enCutscene() = enCutscene
	method switchCutscene() { enCutscene = not(enCutscene) }
	
	method enIntro() = (cuarto.idCuarto() == "_intro")
	
	method cambiarCuarto(nuevoCuarto) {
		cuarto = nuevoCuarto
		cuarto.ingresar()
		self.elegirPuertaIzquierda()
	}

	method moverBajoPuerta() { self.position(puertaElegida.position().down(2)) }
	
	method elegirPuertaIzquierda() { 
		puertaElegida = cuarto.puertaIzquierda()
		self.moverBajoPuerta()
	}
	method elegirPuertaDerecha() {
		puertaElegida = cuarto.puertaDerecha()
		self.moverBajoPuerta()
	}
	
	method usarPuerta() { puertaElegida.usar() }
}

