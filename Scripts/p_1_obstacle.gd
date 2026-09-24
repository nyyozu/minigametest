extends CharacterBody3D

const JUMP_VELOCITY = 3.5
const EMPURRAO = 0.6

@onready var colisao_normal: CollisionShape3D = $CollisionUp
@onready var colisao_abaixado: CollisionShape3D = $CollisionDowned
@onready var animation: AnimatedSprite3D = $AnimatedSprite3D

var esta_abaixado: bool = false
var pode_jogar: bool = true

func _physics_process(delta: float) -> void:
	if not pode_jogar:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("W") and is_on_floor() and not esta_abaixado:
		animation.play("jump")
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("S") and is_on_floor():
		animation.play("down")
		_abaixar(true)
	else:
		_abaixar(false)

	velocity.x = 0
	velocity.z = 0

	move_and_slide()

func _abaixar(valor: bool) -> void:
	esta_abaixado = valor
	colisao_normal.disabled = valor
	colisao_abaixado.disabled = not valor

func levar_hit(direcao_empurrao: Vector3) -> void:
	global_position += direcao_empurrao * EMPURRAO


func _on_death_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
