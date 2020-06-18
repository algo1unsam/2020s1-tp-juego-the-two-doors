import wollok.game.*
import fondos.*
import motores.motorSonoro
import puertas.*

object jugador {
	var property position
	 
	var gameOver = false 
	var enCutscene = false
	var cuarto = null
	var puertaElegida = null

	method image() = if (self.enIntro() or self.enCutscene() or cuarto.sinPuertas()) "invisible.png" else "you.png"
	
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
		fondoOpciones.cambiarFondoSiExiste("izquierda")
		console.println(fondoOpciones.obtenerFondo("izquierda"))
	}
	method elegirPuertaDerecha() {
		puertaElegida = cuarto.puertaDerecha()
		self.moverBajoPuerta()
		fondoOpciones.cambiarFondoSiExiste("derecha")
		console.println(fondoOpciones.obtenerFondo("derecha"))
	}
	
	method usarPuerta() { puertaElegida.usar() }
	
	method empezarDeNuevo(cuartoInicial) {		
		self.toggleGameOver()
		self.cambiarCuarto(cuartoInicial)
		mainFader.fade("off")
		motorSonoro.turnBGM(true)
		self.switchCutscene()
	}
}

