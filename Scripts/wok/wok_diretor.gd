extends Node

const ALTURA_DA_QUEDA = -4.0
const VOLTA_PRO_MENU = 2.5
const PULO_DE_VITORIA = 7.0
const TEMPO_ATE_FOGO = 50.0
const BRILHO_DO_FOGO = 2.2
const VAPOR_MINIMO = 0.15

var acabou = false
var calor = 0.0

@onready var jogador1 = $"../P1"
@onready var jogador2 = $"../P2"
@onready var chapa = $"../Chao/MeshInstance3D"
@onready var corpo = $"../Corpo"
@onready var vapor = $"../Vapor"
@onready var camera = $"../Camera3D"
@onready var folego_p1 = $"../HUD/FolegoP1"
@onready var folego_p2 = $"../HUD/FolegoP2"

func _ready():
	jogador1.rival = jogador2
	jogador2.rival = jogador1
	jogador1.empurrao.connect(_tremer)
	jogador2.empurrao.connect(_tremer)

func _process(delta):
	if acabou:
		return

	calor = minf(calor + delta / TEMPO_ATE_FOGO, 1.0)
	jogador1.calor = calor
	jogador2.calor = calor
	_esquentar()

	folego_p1.value = jogador1.folego
	folego_p2.value = jogador2.folego

	var caiu_1 = jogador1.global_position.y < ALTURA_DA_QUEDA
	var caiu_2 = jogador2.global_position.y < ALTURA_DA_QUEDA

	if caiu_1 and caiu_2:
		terminar(null)
	elif caiu_1:
		terminar(jogador2)
	elif caiu_2:
		terminar(jogador1)

func _esquentar():
	var brilho = calor * calor * BRILHO_DO_FOGO
	chapa.material_override.emission_energy_multiplier = brilho
	corpo.material_override.emission_energy_multiplier = brilho
	vapor.amount_ratio = VAPOR_MINIMO + calor * 0.85

func _tremer(forca):
	camera.tremor = maxf(camera.tremor, forca * 0.02)

func terminar(vencedor):
	acabou = true
	var resultado

	jogador1.rival = null
	jogador2.rival = null

	if vencedor == null:
		print("Empate!")
		resultado = {"empate": true, "vencedor": "", "vencedor_id": -1}
	else:
		print("Venceu: ", vencedor.name)
		vencedor.velocity = Vector3(0, PULO_DE_VITORIA, 0)
		resultado = {
			"empate": false,
			"vencedor": vencedor.name,
			"vencedor_id": vencedor.meu_id,
		}

	await get_tree().create_timer(VOLTA_PRO_MENU).timeout
	GameManager.finalizar_minigame(resultado)