import wollok.game.*

class FondoGrafico {
	const fondosDisponibles = new Dictionary()
	var fondoActual = "none"
	var fondoDefault = "none"
	const fondos = [] //Usada puramente en inicializacion, luego se vacía.
	
	override method initialize() {	
		fondosDisponibles.put("none", "fade/fade100.png")
		fondos.forEach({ elem => self.agregarFondo(elem.get(0).toString(), elem.get(1)) })
		fondos.removeAll(fondos)
		
		if (fondosDisponibles.keys().contains("default"))
			fondoDefault = "default"
		fondoActual = fondoDefault
	}
	
	method agregarFondo(key, valor) { fondosDisponibles.put(key, valor) }
	
	method image() =  fondosDisponibles.get(fondoActual)
	
	method fondosDisponibles() = fondosDisponibles.keys()
	method fondoDefault() = fondosDisponibles.getOrElse("default", fondosDisponibles.get("none") )
	
	method cambiarFondo(nombre){
		if (fondosDisponibles.keys().contains(nombre))
			fondoActual = nombre
		else
			throw new MessageNotUnderstoodException()
	}
	
}

object motorSonoro {
	const sonidoDeFondo = game.sound("sounds/dungeon_ambient_1.ogg")
	const sonidosDisponibles = new Dictionary()
	var sdfMuteado = true // Debug, probando sin usar [...].volume()
	
	method sonidoDeFondo() = sonidoDeFondo
	
	override method initialize() {
		[
			["jail_door", "jail_cell_door.mp3"],
			["tiger", "snd_tiger.ogg"],
			["explosion", "snd_explosion.ogg"]
		].forEach({ elem => sonidosDisponibles.put(elem.get(0).toString(), elem.get(1)) })
		
		sonidoDeFondo.shouldLoop(true)
		sonidoDeFondo.volume(0)
	}
	
	method playSound(nombre) {
		if (sonidosDisponibles.keys().contains(nombre)) {			
			game.sound("sounds/" + sonidosDisponibles.get(nombre)).play()
		}
	}
	
	method switchBGM() {
		if (sdfMuteado)
			sonidoDeFondo.volume(1)
		else
			sonidoDeFondo.volume(0)
		sdfMuteado = not(sdfMuteado)
	}
	method reproducirBGM() {
		sonidoDeFondo.play()
	}
	
}