extends Area3D

@export var tempo_antes_de_resetar: float = 2.0

signal vitoria(jogador: Node3D)

var jogo_acabou: bool = false
var posicoes_iniciais: Dictionary = {}

@export var linhas: Node

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_capturar_posicoes_iniciais()


func _capturar_posicoes_iniciais() -> void:
	var world := get_tree().current_scene
	for nome in ["P1", "P2"]:
		var jogador := world.find_child(nome, true, false)
		if jogador:
			posicoes_iniciais[jogador] = jogador.global_transform
		else:
			push_warning("WinArea: não encontrei o jogador '%s' na cena." % nome)


func _on_body_entered(body: Node3D) -> void:
	if jogo_acabou:
		return
	if body.name != "P1" and body.name != "P2":
		return

	jogo_acabou = true
	_declarar_vitoria(body)


func _declarar_vitoria(jogador: Node3D) -> void:
	print("🏆 ", jogador.name, " venceu o jogo!")
	vitoria.emit(jogador)

	for nome in ["P1", "P2"]:
		var p: Node3D = get_tree().current_scene.find_child(nome, true, false)
		if p:
			p.set_physics_process(false)

	await get_tree().create_timer(tempo_antes_de_resetar).timeout
	_resetar_jogo()


func _resetar_jogo() -> void:
	for jogador in posicoes_iniciais.keys():
		jogador.global_transform = posicoes_iniciais[jogador]
		if "velocity" in jogador:
			jogador.velocity = Vector3.ZERO
		jogador.set_physics_process(true)

	if linhas and linhas.has_method("sortear_tiles_falsos"):
		linhas.sortear_tiles_falsos()
	else:
		push_warning("WinArea: 'linhas_path' não está apontando pro node Linhas certo.")

	jogo_acabou = false
