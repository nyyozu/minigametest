extends Node3D

func _ready() -> void:
	sortear_tiles_falsos()

func sortear_tiles_falsos() -> void:
	for linha in get_children():
		if not linha is Node3D:
			continue

		var tiles_da_linha: Array = linha.get_children()
		if tiles_da_linha.is_empty():
			continue

		for tile in tiles_da_linha:
			tile.is_fake = false
			tile.ja_quebrou = false
			tile.colisao.disabled = false
			tile.mesh.visible = true

		var indice_sorteado = randi() % tiles_da_linha.size()
		tiles_da_linha[indice_sorteado].is_fake = true

		print("Fake na ", linha.name, ": ", tiles_da_linha[indice_sorteado].name)
