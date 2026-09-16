extends StaticBody3D

@export var is_fake: bool = false
@export var tempo_aviso: float = 0.0
@export var tempo_reset: float = 1.5

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var colisao: CollisionShape3D = $CollisionTile01
@onready var area_deteccao: Area3D = $Detec

var ja_quebrou: bool = false

func _ready() -> void:
	if area_deteccao:
		area_deteccao.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if not is_fake or ja_quebrou:
		return

	if body.name == "P1" or body.name == "P2":
		ja_quebrou = true
		quebrar()

	print(name, " detectou: ", body.name, " | is_fake: ", is_fake)
	if not is_fake or ja_quebrou:
		return
		
func quebrar() -> void:
	colisao.disabled = true

	var tween = create_tween()
	tween.tween_property(mesh, "position:y", mesh.position.y - 0.05, 0.05)
	tween.tween_property(mesh, "position:y", mesh.position.y, 0.05)
	tween.set_loops(3)

	await get_tree().create_timer(tempo_aviso).timeout
	mesh.visible = false

	await get_tree().create_timer(tempo_reset).timeout
	colisao.disabled = false
	mesh.visible = true
	ja_quebrou = false
