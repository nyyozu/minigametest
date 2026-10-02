extends CharacterBody3D

signal empurrao(forca)

const VELOCIDADE = 8.0
const GRAVIDADE = 20.0
const EMPURRAO = 14.0
const ALCANCE = 1.0
const ARREMESSO = 1.5
const TONTO = 0.35
const RECARGA = 0.4
const FOLEGO_MAXIMO = 100.0
const CUSTO = 15.0
const RECUPERACAO = 25.0
const CALOR_NO_PUSO = 1.5

@export var tecla_esquerda = "A"
@export var tecla_direita = "D"
@export var tecla_cima = "W"
@export var tecla_baixo = "S"

@export var meu_id = 0

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

var rival = null
var tonto = 0.0
var recarga = 0.0
var folego = FOLEGO_MAXIMO
var calor = 0.0


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
	folego = minf(folego + RECUPERACAO * delta, FOLEGO_MAXIMO)
	_empurrar()

	move_and_slide()

	var andando = Vector2(velocity.x, velocity.z).length() > 0.1
	var animacao = "andando" if andando else "parado"
	if sprite.animation != animacao:
		sprite.play(animacao)
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0


func _empurrar():
	if rival == null or recarga > 0.0 or folego < CUSTO:
		return

	var distancia = global_position.distance_to(rival.global_position)
	if distancia > ALCANCE:
		return

	var para_o_rival = rival.global_position - global_position
	para_o_rival.y = 0
	var forca = EMPURRAO * (1.0 + calor * CALOR_NO_PUSO)
	rival.velocity = rival.velocity + para_o_rival.normalized() * forca
	rival.velocity.y = rival.velocity.y + ARREMESSO
	rival.tonto = TONTO
	folego = folego - CUSTO
	recarga = RECARGA
	empurrao.emit(forca)
