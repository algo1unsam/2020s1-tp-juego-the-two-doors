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

class FadeVisual inherits FondoGrafico {
	const bottomFade = 20
	override method initialize() {
		self.agregarFondo("0", "black.png")
		["20","40","60","80","100"].forEach{num => self.agregarFondo(num, "fade/fade" + num + ".png")}
		fondoDefault = "100"
		super()
	}
	
	method isFaded() = (fondoActual != "100")
	
	method fadeSwitch() { if (self.isFaded()) self.fadeIn() else self.fadeOut()	}
	method fadeIn() { self.fade("fadeIn") }
	method fadeOut() { self.fade("fadeOut") }
	
	method fade(fadeType) {
		var i = 5
		game.onTick(100, fadeType + "_" + self.identity(), {
			var fadeNum = i * 20
			if (fadeType == "fadeIn") fadeNum = 100 - fadeNum
			fadeNum = fadeNum.max(bottomFade).toString()
			self.cambiarFondo(fadeNum)
			i -= 1
			if (i < 0) game.removeTickEvent(fadeType + "_" + self.identity())
		})
	}
}

class MensajeCuarto inherits FondoGrafico {
	const cuarto
	const nombre
	const cuadros
	var cuadroActual = 1
	override method initialize() {
		(1..cuadros).forEach{num => self.agregarFondo(nombre + num.toString(), "rooms/" + cuarto + "/" + nombre + " 0" + num + ".png")}
		fondoActual = nombre + cuadroActual.toString()
		console.println(fondoActual)
		console.println(fondosDisponibles.get(fondoActual))
	}
	method avanzar(){
		if (self.finDeCuarto())
			self.error("Ya no quedan cuadros!")
		cuadroActual += 1
		self.cambiarFondo(nombre + cuadroActual.toString())
	}
	method finDeCuarto() = (cuadroActual == cuadros)
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