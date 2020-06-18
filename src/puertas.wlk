import wollok.game.*
import motores.motorSonoro
import motores.MensajeCuarto
import motores.FadeVisual
import fondos.*
import jugador.*

const ubicacionIzquierda = game.at(9,6)
const ubicacionDerecha = game.at(22,6)

object mapa {
	const opciones = new Dictionary()
	override method initialize() {
		[	
			[  "_intro",	[	["ingresar", "a1", "intro", 3],			["ingresar", "a1", "intro", 3]	]	  ],
			[  "a1",		[	["afilado", "b1", "cuchillo", 4],		["?", "b2", "llave", 4]			]	  ],
			[  "b1",		[	["?", "c1", "tigre", 4],				["muerte", "c2", "muerte", 4]	]	  ],
			[  "b2",		[	["?", "game_over", "duda", 4],			["banana", "c4", "banana", 4]	]	  ],
			[  "c1",		[	["acariciar", "bad_end", "bad", 3],		["?", "good_end", "good", 2]	]	  ],
			[  "c2",		[	["cuchillo", "good_end", "good", 2],	["?", "bad_end", "bad", 2]	]	  ],
			[  "c4",		[	["tarantino", "d1", "maletin", 4],		["?", "d2", "puerta", 4]		]	  ],
			[  "d1",		[	["llave", "bad_end", "bad", 2],			["?", "good_end", "good", 2]	]	  ],
			[  "d2",		[	["llave", "bad_end", "bad", 2],			["?", "good_end", "good", 2]	]	  ]
		].forEach({ elem => opciones.put(elem.get(0).toString(), elem.get(1)) })
		
		/*[ "a1", "b1", "b2", "c1", "c2", "c4", "d1", "d2"].forEach{
			area =>
			console.println("[" + area + "] " + self.opciones(area))
		}*/
	}
	

	method opciones(cuarto) = opciones.get(cuarto).map{ opcion => opcion.get(0) }
	method ruta(cuarto, opcion) = opciones.get(cuarto).get(opcion).get(1)
	method nombreMensaje(cuarto, opcion) = opciones.get(cuarto).get(opcion).get(2)
	method cuadrosMensaje(cuarto, opcion) = opciones.get(cuarto).get(opcion).get(3)
}

class Cuarto {
	const property idCuarto
	const property puertaIzquierda = new Puerta(
		position = ubicacionIzquierda,
		propioCuarto = self,
		idPuerta = 0
	)
	const property puertaDerecha = new Puerta(
		position = ubicacionDerecha,
		propioCuarto = self,
		idPuerta = 1
	)

	method ingresar() {
		if (fondoCuarto.existeFondo(idCuarto)){			
			fondoCuarto.cambiarFondo(idCuarto)
			if (idCuarto != "_intro") [puertaIzquierda, puertaDerecha].forEach{ pue => pue.noEsPuerta() }
		} else {
			fondoCuarto.usarFondoDefault()
		}
	}
	
	method sinPuertas() = ([puertaDerecha, puertaIzquierda].any{elem => not elem.esPuerta()})
}

class Puerta {
	var property position
	var propioCuarto
	var property idPuerta
	var mensajeCuarto = null
	var property enTransicion = false
	var property esPuerta = true
	method noEsPuerta() { esPuerta = false }
	method accion() {
		if (propioCuarto.idCuarto() == "_intro") return "_intro2"
		if (position == ubicacionIzquierda) return "izquierda"
		else if (position == ubicacionDerecha) return "derecha"
		else throw new Exception(message = "Necesito que me ubiquen para accionar!")
	}
	method usar(){
		if (not enTransicion)
			if (jugador.enCutscene())
				self.prepararSigCuarto()
			else
				self.abrir()
	}
	method abrir() {
		enTransicion = true
		jugador.switchCutscene()
		if (esPuerta) {
			fondoCuarto.cambiarFondo(self.accion())
			motorSonoro.playSound("jail_door")
		}
		game.schedule(500, {
			fondoOpciones.cambiarFondo("none")
			if (esPuerta) {
				motorSonoro.playSound("footsteps")
				mainFader.fadeOut()
			}
			if (["good_end", "bad_end"].contains(mapa.ruta(propioCuarto.idCuarto(), idPuerta)))
				motorSonoro.turnBGM(false)
			mensajeCuarto = new MensajeCuarto(
				cuarto = propioCuarto.idCuarto(),
				nombre = mapa.nombreMensaje(propioCuarto.idCuarto(), idPuerta),
				cuadros = mapa.cuadrosMensaje(propioCuarto.idCuarto(), idPuerta)
			)
			const idSiguienteCuarto = mapa.ruta(propioCuarto.idCuarto(), idPuerta)
			const escenaFinal = ["good_end", "bad_end", "game_over"].contains(idSiguienteCuarto)
			var espera1 = 3000
			if (propioCuarto.idCuarto() == "_intro")
				espera1 -= 500
			if (escenaFinal)
				espera1 -= 2000
			game.schedule(espera1, {
				var espera2 = 500
				const fader2 = new FadeVisual()
				//Casos particulares
				game.addVisual(mensajeCuarto)
				const tigreEnojado = propioCuarto.idCuarto() == "c1" and mensajeCuarto.nombre() == "bad"
				if (tigreEnojado) {
					motorSonoro.playSound("tiger")
					console.println("test")
					espera2 += 4700
					game.schedule(espera2, {
						self.prepararSigCuarto()
					})
				} else if ( not escenaFinal ) {
					fader2.fade("on")
					game.addVisual(fader2)
					fader2.fadeIn()
				}
				game.schedule(espera2, {				
					if (game.hasVisual(fader2)) game.removeVisual(fader2)
					console.println(mensajeCuarto.cuarto() + " - " + mensajeCuarto.nombre())
					enTransicion = false
				})
			})
		})
	}
	method prepararSigCuarto() {
		if (mensajeCuarto.finDeCuarto()) {
			enTransicion = true
			const idSiguienteCuarto = mapa.ruta(propioCuarto.idCuarto(), idPuerta)
			if (["good_end", "bad_end", "game_over"].contains(idSiguienteCuarto)) {
				mainFader.fade("on")
				game.removeVisual(mensajeCuarto)
				fondoCuarto.cambiarFondo("game_over")
				fondoOpciones.reemplazarFondos("none")
				mainFader.fadeIn()
				game.schedule(500, {					
					jugador.toggleGameOver()
				})
			} else {			
				const siguienteCuarto = new Cuarto(idCuarto = idSiguienteCuarto)
				siguienteCuarto.puertaIzquierda().enTransicion(true)
				fondoOpciones.reemplazarFondos(idSiguienteCuarto)
				jugador.cambiarCuarto(siguienteCuarto)
				fondoOpciones.cambiarFondo("none")
				game.removeVisual(mensajeCuarto)
				if (fondoCuarto.existeFondo(idSiguienteCuarto))
					mainFader.fade("off")
				else
					mainFader.fadeIn()
				game.schedule(1000, {
					fondoOpciones.cambiarFondo("izquierda")
					jugador.switchCutscene()
					enTransicion = false
					siguienteCuarto.puertaIzquierda().enTransicion(false)
				})
				
			}
			
		}
		else
			mensajeCuarto.avanzar()
	}
}