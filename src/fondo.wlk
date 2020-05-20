import wollok.game.*

object fondoGrafico {
	const fondosDisponibles = new Dictionary()
	
	var property fondoActual = "default"
	method image() =  fondosDisponibles.get(fondoActual)
	override method initialize() {
		[
			["default", "back.png"],
			["izquierda", "izquierda_abierta.png"],
			["derecha", "derecha_abierta.png"],
			["none", "negro.png"]
		].forEach({ elem => fondosDisponibles.put(elem.get(0).toString(), elem.get(1)) })
	}
	
	method fondoDefault() = fondosDisponibles.get("default")
	method cambiarFondo(nombre){
		if (fondosDisponibles.keys().contains(nombre))
			fondoActual = nombre
		else
			throw new MessageNotUnderstoodException()
	}
	
}

object motorSonoro {
	const sonidoDeFondo = game.sound("dungeon_ambient_1.ogg")
	const sonidosDisponibles = new Dictionary()
	var sdfMuteado = true // Debug, probando sin usar [...].volume()
	
	method sonidoDeFondo() = sonidoDeFondo
	
	override method initialize() {
		[
			["tiger", "snd_tiger.ogg"],
			["explosion", "snd_explosion.ogg"]
		].forEach({ elem => sonidosDisponibles.put(elem.get(0).toString(), elem.get(1)) })
		
		sonidoDeFondo.shouldLoop(true)
		sonidoDeFondo.volume(0)
	}
	
	method playSound(nombre) {
		if (sonidosDisponibles.keys().contains(nombre)) {			
			game.sound(sonidosDisponibles.get(nombre)).play()
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
		console.println("holi")
		sonidoDeFondo.play()
	}
	
}