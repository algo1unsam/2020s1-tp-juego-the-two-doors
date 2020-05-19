import fondo.*

class Puerta {
	var property position
	var property accion = "default"
	method abrir() {
		fondoGrafico.cambiarFondo(accion)
	}
}