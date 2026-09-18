extends Node

const MENU_PATH := "res://scenes/menu/menu_selecao.tscn"

var ultimo_resultado = {}

func iniciar_minigame(caminho_da_cena: String) -> void:
	get_tree().change_scene_to_file(caminho_da_cena)

func finalizar_minigame(resultado: Dictionary = {}) -> void:
	ultimo_resultado = resultado
	get_tree().change_scene_to_file(MENU_PATH)
