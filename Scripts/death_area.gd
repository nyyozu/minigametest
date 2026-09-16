extends Area3D

@export var tempo_delay: float = 2.0

var posicoes_iniciais: Dictionary = {}

var em_respawn: Dictionary = {}


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_capturar_posicoes_iniciais()


func _capturar_posicoes_iniciais() -> void:
	var world := get_tree().current_scene
	for nome in ["P1", "P2"]:
		var jogador := world.find_child(nome, true, false)
		if jogador:
			posicoes_iniciais[jogador] = jogador.global_transform
			em_respawn[jogador] = false
		else:
			push_warning("DeathArea: não encontrei o jogador '%s' na cena." % nome)


func _on_body_entered(body: Node3D) -> void:
	if body.name != "P1" and body.name != "P2":
		return

	if not posicoes_iniciais.has(body):
		return

	if em_respawn.get(body, false):
		return

	em_respawn[body] = true
	_respawnar(body)


func _respawnar(body: Node3D) -> void:
	body.set_physics_process(false)
	body.visible = false

	if "velocity" in body:
		body.velocity = Vector3.ZERO
	if body is RigidBody3D:
		body.linear_velocity = Vector3.ZERO
		body.angular_velocity = Vector3.ZERO

	await get_tree().create_timer(tempo_delay).timeout

	body.global_transform = posicoes_iniciais[body]

	body.visible = true
	body.set_physics_process(true)
	em_respawn[body] = false
