import wollok.game.*

class FondoGrafico {
	const fondosDisponibles = new Dictionary()
	var fondoActual = "none"
	var fondoDefault = "none"
	const fondos = [] //Usada puramente en inicializacion, luego se vacía.
	
	var property position = game.at(0,0)
	
	method image() =  fondosDisponibles.get(fondoActual)
	
	override method initialize() {	
		self.agregarFondo("none", "fade/fade100.png")
		fondos.forEach({ elem => self.agregarFondo(elem.get(0).toString(), elem.get(1)) })
		fondos.removeAll(fondos)
		
		if (self.existeFondo("default"))
			fondoDefault = "default"
		self.usarFondoDefault()
	}
	
	method fondosDisponibles() = fondosDisponibles.keys()
	method agregarFondo(key, valor) { fondosDisponibles.put(key, valor) }
	
	method usarFondoDefault() { fondoActual = fondoDefault }
	
	method existeFondo(nombre) = fondosDisponibles.keys().contains(nombre)
	method validarFondo(nombre) {
		if ( not self.existeFondo(nombre))
			self.error("No existe el fondo indicado:" + nombre)
	}
	method obtenerFondo(nombre) {
		if (self.existeFondo(nombre))
			return fondosDisponibles.get(nombre)
		else
			return "No existe este fondo"
	}
	
	method cambiarFondo(nombre){
		self.validarFondo(nombre)
		fondoActual = nombre
	}
	
	method cambiarFondoSiExiste(nombre) { if (self.existeFondo(nombre)) self.cambiarFondo(nombre)}
	
	method reemplazarFondos(idCuarto) {
		fondoDefault = "none"
		self.usarFondoDefault()
		["izquierda", "derecha"].forEach{
			dir =>
			const ruta = (
				if (idCuarto == "none") 
					"fade/fade100.png"
				else
					"rooms/" + idCuarto.toString() + "/opcion_" + dir + ".png"
			)
			self.agregarFondo(dir, ruta)
		}
	}
	
}

class FadeVisual inherits FondoGrafico {
	const bottomFade = 20
	const topFade = 100
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
		if (fadeType == "off") {
			self.cambiarFondo(topFade.toString())
		} else if (fadeType == "on") {
			self.cambiarFondo(bottomFade.toString())
		} else {			
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
}

class MensajeCuarto inherits FondoGrafico {
	const property cuarto
	const property nombre
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
	var sdfMuteado = false // Debug, probando sin usar [...].volume()
	
	method sonidoDeFondo() = sonidoDeFondo
	
	override method initialize() {
		[
			["jail_door", "jail_cell_door.mp3"],
			["footsteps", "footsteps.ogg"],
			["tiger", "snd_tiger.ogg"],
			["lock_opened", "lock_opened.wav"],
			["door_stuck", "door_stuck.mp3"],
			["explosion", "snd_explosion.ogg"]
		].forEach({ elem => sonidosDisponibles.put(elem.get(0).toString(), elem.get(1)) })
		
		sonidoDeFondo.shouldLoop(true)
	}
	
	method playSound(nombre) {
		if (sonidosDisponibles.keys().contains(nombre)) {			
			game.sound("sounds/" + sonidosDisponibles.get(nombre)).play()
		}
	}
	
	method turnBGM(encender){
		sonidoDeFondo.volume(if (encender) 1 else 0)
		sdfMuteado = encender
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