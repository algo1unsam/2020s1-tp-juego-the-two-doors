import fondo.*

class Puerta {
	var property position
	var property accion = "default"
	method abrir() {
		motorSonoro.playSound("jail_door")
		fondoGrafico.cambiarFondo(accion)
	}
}
class Cuarto {
	
}