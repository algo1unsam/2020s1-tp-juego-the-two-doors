import wollok.game.*
import motores.motorSonoro
import motores.MensajeCuarto
import fondos.*
import jugador.*

const ubicacionIzquierda = game.at(9,6)
const ubicacionDerecha = game.at(22,6)

class Puerta {
	var property position
	var propioCuarto
	var property idPuerta
	var datosSigCuarto = []
	var siguienteCuarto = null
	var mensajeCuarto = null
	method accion() {
		if (position == ubicacionIzquierda) return "izquierda"
		else if (position == ubicacionDerecha) return "derecha"
		else throw new Exception(message = "Necesito que me ubiquen para accionar!")
	}
	method usar(){
		if (jugador.enCutscene())
			self.prepararSigCuarto()
		else
			self.abrir()
	}
	method abrir() {
		fondoCuarto.cambiarFondo(self.accion())
		motorSonoro.playSound("jail_door")
		game.schedule(500, {
			jugador.switchCutscene()
			fader.fadeOut()
			game.schedule(1000, {
				datosSigCuarto = mapa.ruta(propioCuarto.idCuarto(), idPuerta)
				mensajeCuarto = new MensajeCuarto(
					cuarto = propioCuarto.idCuarto(),
					nombre = mapa.nombreMensaje(propioCuarto.idCuarto(), idPuerta),
					cuadros = mapa.cuadrosMensaje(propioCuarto.idCuarto(), idPuerta)
				)
				game.addVisualIn(mensajeCuarto, game.at(0,0))
				/*fader.fadeIn()
				jugador.switchCutscene()*/ //Esto al terminar, no aca
			})
		})
	}
	method prepararSigCuarto() {
		//TODO: Autogenerated Code ! 
		if (mensajeCuarto.finDeCuarto())
			self.error("FIN")
		else
			mensajeCuarto.avanzar()
	}
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
	
	override method initialize() {
	}
}

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