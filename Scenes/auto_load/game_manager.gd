extends Node

const MENU_PATH := "res://scenes/menu/menu_selecao.tscn"

var ultimo_resultado = {}

var vitorias: Array[int] = [0, 0]

func iniciar_minigame(caminho_da_cena: String) -> void:
	get_tree().change_scene_to_file(caminho_da_cena)

func finalizar_minigame(resultado: Dictionary = {}) -> void:
	ultimo_resultado = resultado
	_registrar_vitoria(resultado)
	get_tree().change_scene_to_file(MENU_PATH)

func _registrar_vitoria(resultado: Dictionary) -> void:
	if resultado.get("empate", false):
		return
	var id: int = resultado.get("vencedor_id", -1)
	if id >= 0 and id < vitorias.size():
		vitorias[id] += 1

func resetar_placar() -> void:
	vitorias = [0, 0]
