extends Node

const ALTURA_DA_QUEDA = -4.0
const VOLTA_PRO_MENU = 2.5
const PULO_DE_VITORIA = 7.0

var acabou = false

@onready var jogador1 = $"../P1"
@onready var jogador2 = $"../P2"

func _ready():
	jogador1.rival = jogador2
	jogador2.rival = jogador1

func _process(delta):
	if acabou:
		return

	var caiu_1 = jogador1.global_position.y < ALTURA_DA_QUEDA
	var caiu_2 = jogador2.global_position.y < ALTURA_DA_QUEDA

	if caiu_1 and caiu_2:
		terminar(null)
	elif caiu_1:
		terminar(jogador2)
	elif caiu_2:
		terminar(jogador1)

func terminar(vencedor):
	acabou = true
	var resultado

	# ninguem empurra mais ninguem depois que a rodada acabou
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
