extends CharacterBody3D

const JUMP_VELOCITY = 3.1
const EMPURRAO = 0.6
const COR_EM_PE := Color(0.55, 0.78, 0.95)
const COR_ABAIXADO := Color(0.98, 0.72, 0.35)

@onready var colisao_normal: CollisionShape3D = $CollisionUp
@onready var colisao_abaixado: CollisionShape3D = $CollisionDowned
@onready var animation: AnimatedSprite3D = $AnimatedSprite3D
@onready var hitbox: MeshInstance3D = $Hitbox

var esta_abaixado: bool = false
var pode_jogar: bool = true


func _ready() -> void:
	_atualizar_hitbox()


func _physics_process(delta: float) -> void:
	if not pode_jogar:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	# just_pressed: cada pulo exige um comando novo. Segurar a tecla
	# nao pode gerar pulo infinito, senao nunca ha tempo de abaixar.
	if Input.is_action_just_pressed("W") and is_on_floor() and not esta_abaixado:
		velocity.y = JUMP_VELOCITY

	_abaixar(Input.is_action_pressed("S") and is_on_floor())

	velocity.x = 0
	velocity.z = 0

	move_and_slide()
	_atualizar_animacao()


# --- Estado de abaixar: troca a colisao e avisa so quando muda ---

func _abaixar(valor: bool) -> void:
	if valor == esta_abaixado:
		return
	esta_abaixado = valor
	colisao_normal.disabled = valor
	colisao_abaixado.disabled = not valor
	_atualizar_hitbox()


# --- Animacao: uma pose por estado, sem ficar travada ---

func _atualizar_animacao() -> void:
	var pose := "idle"
	if not is_on_floor():
		pose = "jump"
	elif esta_abaixado:
		pose = "down"
	if animation.animation != pose:
		animation.play(pose)


# --- Visual do colisor ativo ---

func _atualizar_hitbox() -> void:
	var ativa: CollisionShape3D = colisao_abaixado if esta_abaixado else colisao_normal
	var caps: CapsuleShape3D = ativa.shape
	hitbox.position = ativa.position
	hitbox.scale = Vector3(caps.radius * 2.0, caps.height, caps.radius * 2.0)
	var mat: StandardMaterial3D = hitbox.material_override
	if mat:
		# 注意: Color + Color soma os canais e satura. Montar o RGBA na mao.
		var c: Color = COR_ABAIXADO if esta_abaixado else COR_EM_PE
		mat.albedo_color = Color(c.r, c.g, c.b, 0.18)


func levar_hit(direcao_empurrao: Vector3) -> void:
	global_position += direcao_empurrao * EMPURRAO


func _on_death_area_body_entered(body: Node3D) -> void:
	pass
