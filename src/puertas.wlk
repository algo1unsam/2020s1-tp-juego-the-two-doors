import wollok.game.*
import motores.motorSonoro
import motores.MensajeCuarto
import fondos.*
import jugador.*

const ubicacionIzquierda = game.at(9,6)
const ubicacionDerecha = game.at(22,6)

object mapa {
	const opciones = new Dictionary()
	override method initialize() {
		[
			[  "a1", [	["afilado", "b1", "cuchillo", 4],		["?", "b2", "llave", 4]			]  ],
			[  "b1", [	["?", "c1", "tigre", 4],				["muerte", "c2", "muerte", 4]	]  ],
			[  "b2", [	["?", "game_over", "duda", 4],			["banana", "c4", "banana", 4]	]  ],
			[  "c1", [	["acariciar", "bad_end", "bad", 3],		["?", "good_end", "good", 2]	]  ],
			[  "c2", [	["cuchillo", "bad_end", "bad", 2],		["?", "good_end", "good", 2]	]  ],
			[  "c4", [	["tarantino", "d1", "maletin", 4],		["?", "d2", "puerta", 4]		]  ],
			[  "d1", [	["llave", "bad_end", "bad", 2],			["?", "good_end", "good", 2]	]  ],
			[  "d2", [	["llave", "bad_end", "bad", 2],			["?", "good_end", "good", 2]	]  ]
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
			[puertaIzquierda, puertaDerecha].forEach{ pue => pue.noEsPuerta() }
		} else {
			fondoCuarto.usarFondoDefault()
		}
	}
}

class Puerta {
	var property position
	var propioCuarto
	var property idPuerta
	var datosSigCuarto = []
	var mensajeCuarto = null
	var property enTransicion = false
	var property esPuerta = true
	method noEsPuerta() { esPuerta = false }
	method accion() {
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
		if (esPuerta) {			
			fondoCuarto.cambiarFondo(self.accion())
			motorSonoro.playSound("jail_door")
		}
		game.schedule(500, {
			jugador.switchCutscene()
			if (esPuerta) fader.fadeOut()
			game.schedule(1000, {
				datosSigCuarto = mapa.ruta(propioCuarto.idCuarto(), idPuerta)
				mensajeCuarto = new MensajeCuarto(
					cuarto = propioCuarto.idCuarto(),
					nombre = mapa.nombreMensaje(propioCuarto.idCuarto(), idPuerta),
					cuadros = mapa.cuadrosMensaje(propioCuarto.idCuarto(), idPuerta)
				)
				game.addVisualIn(mensajeCuarto, game.at(0,0))
				//Casos particulares
				console.println(mensajeCuarto.cuarto() + " - " + mensajeCuarto.nombre())
				if (mensajeCuarto.cuarto() == "c1" and mensajeCuarto.nombre() == "bad") {
					motorSonoro.playSound("tiger")
					console.println("test")
					game.schedule(5200, {
						self.prepararSigCuarto()
						enTransicion = false
					})
				} else {
					enTransicion = false
				}
			})
		})
	}
	method prepararSigCuarto() {
		if (mensajeCuarto.finDeCuarto()) {
			enTransicion = true
			const idSiguienteCuarto = mapa.ruta(propioCuarto.idCuarto(), idPuerta)
			if (["good_end", "bad_end", "game_over"].contains(idSiguienteCuarto))
				self.error("GAME OVER:" + idSiguienteCuarto)
			else {			
				const siguienteCuarto = new Cuarto(idCuarto = idSiguienteCuarto)
				siguienteCuarto.puertaIzquierda().enTransicion(true)
				jugador.cambiarCuarto(siguienteCuarto)
				game.removeVisual(mensajeCuarto)
				if (fondoCuarto.existeFondo(idSiguienteCuarto))
					fader.fade("off")
				else
					fader.fadeIn()
				game.schedule(1000, {	
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