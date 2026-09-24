extends Area3D

@onready var p1: CharacterBody3D = $"../P1"
@onready var p2: CharacterBody3D = $"../P2"
@onready var spawner: Node = $"../Spawner_Obstacle"

@export_file("*.tscn") var cena_menu: String = "res://scenes/menu/menu_selecao.tscn"
@export var janela_empate: float = 0.15
@export var delay_voltar_menu: float = 3.0

var _caidos: Array[Node3D] = []
var _finalizado: bool = false
var _label: Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_criar_label()

func _on_body_entered(body: Node3D) -> void:
	if _finalizado:
		return
	if body != p1 and body != p2:
		return
	if body in _caidos:
		return

	_caidos.append(body)

	if _caidos.size() == 1:
		await get_tree().create_timer(janela_empate).timeout
		_resolver()

var vencedor: CharacterBody3D = null   # null = empate

func _resolver() -> void:
	if _finalizado:
		return
	_finalizado = true

	if spawner and spawner.has_method("parar"):
		spawner.parar()

	for p in [p1, p2]:
		if p and "pode_jogar" in p:
			p.pode_jogar = false

	var mensagem: String
	if _caidos.size() >= 2:
		mensagem = "EMPATE!"
		vencedor = null
	else:
		vencedor = p2 if _caidos[0] == p1 else p1
		mensagem = vencedor.name + " VENCEU!"

	_mostrar_mensagem(mensagem)

	var resultado := {
		"empate": vencedor == null,
		"vencedor": "" if vencedor == null else String(vencedor.name),  # "P1" ou "P2"
		"vencedor_id": -1 if vencedor == null else (0 if vencedor == p1 else 1),
	}

	await get_tree().create_timer(delay_voltar_menu).timeout
	GameManager.finalizar_minigame(resultado)
	
func _criar_label() -> void:
	var camada := CanvasLayer.new()
	add_child(camada)

	_label = Label.new()
	_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", 72)
	_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_label.add_theme_constant_override("outline_size", 12)
	_label.visible = false
	camada.add_child(_label)

func _mostrar_mensagem(texto: String) -> void:
	_label.text = texto
	_label.visible = true
