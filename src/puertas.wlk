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
	
}