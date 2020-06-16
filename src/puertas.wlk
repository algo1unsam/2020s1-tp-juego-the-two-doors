import wollok.game.*
import motores.motorSonoro
import fondos.*

const ubicacionIzquierda = game.at(9,6)
const ubicacionDerecha = game.at(22,6)

class Puerta {
	var property position
	var property accion = "default"
	method accion() {
		if (position == ubicacionIzquierda) return "izquierda"
		else if (position == ubicacionDerecha) return "derecha"
		else throw new Exception(message = "Necesito que me ubiquen para accionar!")
	}
	method abrir() {
		motorSonoro.playSound("jail_door")
		fondoCuarto.cambiarFondo(self.accion())
	}
}

class Cuarto {
	
}

object mapa {
	const opciones = new Dictionary()
	override method initialize() {
		[
			[  "a1", [	["afilado", "b1"],			["?", "b2"]			]  ],
			[  "b1", [	["?", "c1"],				["muerte", "c2"]	]  ],
			[  "b2", [	["?", "game_over"],			["banana", "c4"]	]  ],
			[  "c1", [	["acariciar", "game_over"],	["?", "game_over"]	]  ],
			[  "c2", [	["cuchillo", "game_over"],	["?", "game_over"]	]  ],
			[  "c4", [	["tarantino", "d1"],		["?", "d2"]			]  ],
			[  "d1", [	["llave", "bad_end"],		["?", "good_end"]	]  ],
			[  "d2", [	["llave", "bad_end"],		["?", "good_end"]	]  ]
		].forEach({ elem => opciones.put(elem.get(0).toString(), elem.get(1)) })
		
		[ "a1", "b1", "b2", "c1", "c2", "c4", "d1", "d2"].forEach{
			area =>
			console.println("[" + area + "] " + self.opciones(area))
			console.println("<IZQ< " + self.rutaIzquierda(area))
			console.println(">DER> " + self.rutaDerecha(area))
		}
	}
	
	method opciones(cuarto) = opciones.get(cuarto).map{ opcion => opcion.get(0) }
	method ruta(cuarto, opcion) = opciones.get(cuarto).get(opcion).get(1)
	method rutaIzquierda(cuarto) = self.ruta(cuarto, 0)
	method rutaDerecha(cuarto) = self.ruta(cuarto, 1)
	
	
}