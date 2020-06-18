import wollok.game.*
import fondos.*
import motores.motorSonoro
import cuartos.*

object jugador {
	var property position
	 
	var gameOver = false 
	var enCutscene = false
	var cuarto = null
	var opcionElegida = null

	method image() = if (self.enIntro() or self.enCutscene() or cuarto.sinPuertas()) "invisible.png" else "you.png"
	
	method opcionElegida() = opcionElegida //Para testeo
	
	method esGameOver() = gameOver
	method toggleGameOver() { gameOver = not(gameOver) }
	
	method enCutscene() = enCutscene
	method switchCutscene() { enCutscene = not(enCutscene) }
	
	method enIntro() = (cuarto.idCuarto() == "_intro")
	
	method cambiarCuarto(nuevoCuarto) {
		cuarto = nuevoCuarto
		cuarto.ingresar()
		self.elegirOpcionIzquierda()
	}

	method moverBajoOpcion() { self.position(opcionElegida.position().down(2)) }
	
	method elegirOpcionIzquierda() { 
		opcionElegida = cuarto.opcionIzquierda()
		self.moverBajoOpcion()
		fondoOpciones.cambiarFondoSiExiste("izquierda")
		//console.println(fondoOpciones.obtenerFondo("izquierda"))
	}
	method elegirOpcionDerecha() {		
		opcionElegida = cuarto.opcionDerecha()
		self.moverBajoOpcion()
		fondoOpciones.cambiarFondoSiExiste("derecha")
		//console.println(fondoOpciones.obtenerFondo("derecha"))
	}
	
	method accionar() { 
		opcionElegida.usar()
	}
	
	method empezarDeNuevo(cuartoInicial) {		
		self.toggleGameOver()
		self.cambiarCuarto(cuartoInicial)
		mainFader.fade("off")
		motorSonoro.turnBGM(true)
		self.switchCutscene()
	}
}

