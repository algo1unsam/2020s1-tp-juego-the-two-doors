import motores.motorSonoro
import fondos.*

class Puerta {
	var property position
	var property accion = "default"
	method abrir() {
		motorSonoro.playSound("jail_door")
		fondoCuarto.cambiarFondo(accion)
	}
}

class Cuarto {
	

object mapa {
	const opciones = new Dictionary()
	override method initialize() {
		[
			["a1", ["afilado", "?"],	["b1", "b2"]],
			["b1", ["?", "muerte"],		["c1", "c2"]],
			["b2", ["?", "banana"],		["game_over", "c4"]],
			["c1", ["acariciar", "?"],	["game_over", "game_over"]],
			["c2", ["cuchillo", "?"],	["game_over", "game_over"]],
			["c3", [], []],
			["c4", ["tarantino", "?"],	["d1", "d2"]],
			["d1", ["llave", "?"],		["bad_end", "good_end"]],
			["d2", ["llave", "?"],		["bad_end", "good_end"]]
		].forEach({ elem => opciones.put(elem.get(0).toString(), elem.get(1)) })
	}
	
	method opciones(cuarto) = opciones.get(cuarto)
}