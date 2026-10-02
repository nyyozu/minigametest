extends Node3D

const ALTURA = 8.0
const RECUO_MINIMO = 9.5
const RECUO_POR_UNIDADE = 0.5
const RECUO_MAXIMO = 22.0
const SUAVIZACAO = 6.0
const PERDA_DO_TREMOR = 4.0

@onready var jogador1 = $"../P1"
@onready var jogador2 = $"../P2"

var tremor = 0.0

func _process(delta):
	var meio = (jogador1.global_position + jogador2.global_position) * 0.5
	var separacao = jogador1.global_position.distance_to(jogador2.global_position)

	var recuo = RECUO_MINIMO + RECUO_POR_UNIDADE * separacao
	recuo = minf(recuo, RECUO_MAXIMO)

	var alvo = Vector3(meio.x, ALTURA, meio.z + recuo)
	var suave = clampf(delta * SUAVIZACAO, 0.0, 1.0)
	global_position = global_position.lerp(alvo, suave)

	tremor = maxf(tremor - delta * PERDA_DO_TREMOR, 0.0)
	if tremor > 0.0:
		global_position = global_position + Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), 0.0) * tremor

	var chao = Vector3(meio.x, 0.0, meio.z)
	if global_position.distance_to(chao) > 0.5:
		look_at(chao, Vector3.UP)