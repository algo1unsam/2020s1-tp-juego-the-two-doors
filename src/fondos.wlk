import motores.*

const fondoCuarto = new FondoGrafico(
	fondos = [
		["default", "back.png"],
		["_intro", "portada.png"],
		["_intro2", "portada2.png"],
		["game_over", "game_over.png"],
		["izquierda", "izquierda_abierta.png"],
		["derecha", "derecha_abierta.png"],
		["c1", "rooms/c1/_choice.png"],
		["c2", "rooms/c2/_choice.png"],
		["d1", "rooms/d1/_choice.png"],
		["d2", "rooms/d2/_choice.png"]
	]
)

const fondoOpciones = new FondoGrafico(
	fondos = []
)

const mainFader = new FadeVisual()