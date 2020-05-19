import wollok.game.*

object fondoGrafico {
	const fondosDisponibles = new Dictionary()
	
	var property fondoActual = "default"
	method image() =  fondosDisponibles.get(fondoActual)
	override method initialize() {
		[
			["default", "back.png"],
			["izquierda", "izquierda_abierta.png"],
			["derecha", "derecha_abierta.png"],
			["none", "negro.png"]
		].forEach({ elem => fondosDisponibles.put(elem.get(0).toString(), elem.get(1)) })
	}
	
	method fondoDefault() = fondosDisponibles.get("default")
	method cambiarFondo(nombre){
		if (fondosDisponibles.keys().contains(nombre))
			fondoActual = nombre
		else
			throw new MessageNotUnderstoodException()
	}
	
}