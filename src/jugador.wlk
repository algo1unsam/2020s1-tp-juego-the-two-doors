import wollok.game.*

object jugador {
	var property position 
	var puerta = null
	var enCutscene = false

	method image() = if (enCutscene) "invisible.png" else "you.png"
	
	method switchCutscene() { enCutscene = not(enCutscene) }
	
	method elegirPuerta(nuevaPuerta) {
		self.position(puerta.position().down(2))
		puerta = nuevaPuerta
	}
	
	method abrirPuerta() {
		if (puerta != null){
			puerta.abrir()
		}
	}
}

