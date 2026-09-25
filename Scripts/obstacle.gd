extends Area3D

enum Tipo { BAIXO, ALTO }

@onready var sprite: Sprite3D = $Sprite3D
@export var tipo: Tipo = Tipo.BAIXO
@export var velocidade: float = 6.0
@export var direcao_empurrao_no_hit: Vector3 = Vector3(-1, 0, 0)
@export var altura_baixo: float = 0.3
@export var altura_alto: float = 1.1
@export var distancia_limite: float = 30.0

var _ja_acertou := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	position.y = altura_baixo if tipo == Tipo.BAIXO else altura_alto
	sprite.texture = load(
		"res://assets/obstacle/obst_baixo.svg" if tipo == Tipo.BAIXO
		else "res://assets/obstacle/obst_alto.svg"
	)

func _physics_process(delta: float) -> void:
	position.x -= velocidade * delta
	if position.x < -distancia_limite:
		queue_free()
	# so o caldeirao do chao rola; o suspenso fica parado
	if tipo == Tipo.BAIXO:
		sprite.rotation.x += 6.0 * delta

var alvo: Node3D = null

func _on_body_entered(body: Node3D) -> void:
	if _ja_acertou:
		return
	if body != alvo:
		return
	if body.has_method("levar_hit"):
		_ja_acertou = true
		body.levar_hit(direcao_empurrao_no_hit)
		queue_free()
