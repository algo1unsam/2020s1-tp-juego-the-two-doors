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
			["a0", ["afilado", "?"]],
			["b0", ["?", "muerte"]],
			["b1", ["?", "banana"]],
			["c0", ["acariciar", "?"]],
			["c1", ["cuchillo", "?"]],
			["c2", null],
			["c3", ["tarantino", "?"]],
			["d6", ["llave", "?"]],
			["d7", ["llave", "?"]]
		].forEach({ elem => opciones.put(elem.get(0).toString(), elem.get(1)) })
	}
	
	method opciones(cuarto) = opciones.get(cuarto)
}