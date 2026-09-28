extends CharacterBody3D

const VELOCIDADE = 8.0
const GRAVIDADE = 20.0
const EMPURRAO = 14.0
const ALCANCE = 1.0
const ARREMESSO = 1.5
const TONTO = 0.35
const RECARGA = 0.4

@export var tecla_esquerda = "A"
@export var tecla_direita = "D"
@export var tecla_cima = "W"
@export var tecla_baixo = "S"

@export var meu_id = 0

@onready var sprite: Sprite3D = $Sprite3D

var rival = null
var tonto = 0.0
var recarga = 0.0


func _physics_process(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y = velocity.y - GRAVIDADE * delta

	if tonto > 0.0:
		tonto = tonto - delta
	else:
		var direcao = Input.get_vector(tecla_esquerda, tecla_direita, tecla_cima, tecla_baixo)
		velocity.x = direcao.x * VELOCIDADE
		velocity.z = direcao.y * VELOCIDADE

	recarga = recarga - delta
	_empurrar()

	move_and_slide()

	# vira o boneco pro lado em que ta andando
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0


func _empurrar():
	if rival == null or recarga > 0.0:
		return

	var distancia = global_position.distance_to(rival.global_position)
	if distancia > ALCANCE:
		return

	var para_o_rival = rival.global_position - global_position
	para_o_rival.y = 0
	rival.velocity = rival.velocity + para_o_rival.normalized() * EMPURRAO
	rival.velocity.y = rival.velocity.y + ARREMESSO
	rival.tonto = TONTO
	recarga = RECARGA
