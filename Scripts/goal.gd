extends Area3D

@export var tempo_antes_de_finalizar: float = 2.5

@onready var win_label: = $"../../Win Canva/Win Label"

signal vitoria(jogador: Node3D)

var jogo_acabou: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if jogo_acabou:
		return
	if body.name != "P1" and body.name != "P2":
		return

	jogo_acabou = true
	_declarar_vitoria(body)

func _declarar_vitoria(jogador: Node3D) -> void:
	print("🏆 ", jogador.name, " venceu o jogo!")
	win_label.show()
	vitoria.emit(jogador)

	for nome in ["P1", "P2"]:
		var p: Node3D = get_tree().current_scene.find_child(nome, true, false)
		if p:
			p.set_physics_process(false)

	await get_tree().create_timer(tempo_antes_de_finalizar).timeout
	win_label.hide()
	GameManager.finalizar_minigame({"vencedor": jogador.name})
