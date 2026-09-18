extends Control

func _on_botao_tiles_falsos_pressed() -> void:
	GameManager.iniciar_minigame("res://scenes/minigames/fake tiles.tscn")

func _on_botao_outro_minigame_pressed() -> void:
	GameManager.iniciar_minigame("res://scenes/minigames/fake tiles.tscn")
