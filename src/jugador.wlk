import wollok.game.*

object jugador {
	var property position 
	var puerta = null
	//var cuarto = cuartoInicial
	var enCutscene = false
	method enCutscene() = enCutscene

	method image() = if (enCutscene) "invisible.png" else "you.png"
	
	method switchCutscene() { enCutscene = not(enCutscene) }
	
	method elegirPuerta(nuevaPuerta) {
		self.position(nuevaPuerta.position().down(2))
		puerta = nuevaPuerta
	}
	
	method usarPuerta() { puerta.usar()	}
}

