extends Control

const COR_BRANCO := Color("#F2EFE6")
const COR_OURO := Color("#E8A33D")
const VELOCIDADE_VAPOR := 0.10

@onready var placar_painel: PanelContainer = $Placar
@onready var cabecalho: PanelContainer = $Cabecalho
@onready var P1: Label = %P1
@onready var P2: Label = %P2
@onready var botao_tiles: Button = %fake_tiles
@onready var botao_obstacle: Button = %obstacle
@onready var animationp1: AnimatedSprite2D = %P1_SPRITE
@onready var animationp2: AnimatedSprite2D = %P2_SPRITE


func _ready() -> void:
	_atualizar_placar()
	_tematizar_placar()
	_tematizar_cabecalho()
	_preparar_botao(botao_tiles, "Minigame 1\nFake Tiles", "res://assets/menu/icone_panelas.svg")
	_preparar_botao(botao_obstacle, "Minigame 2\nObstacle", "res://assets/menu/icone_utensilios.svg")
	animationp1.play("default")
	animationp2.play("default")


# --- "Vida" do cenário: vapor subindo dos temperos na bancada ---

func _process(delta: float) -> void:
	_derivar_vapor($Vapor/Tomilho, VELOCIDADE_VAPOR, delta)
	_derivar_vapor($Vapor/Alecrim, -VELOCIDADE_VAPOR * 0.7, delta)
	_derivar_vapor($Vapor/Canela, VELOCIDADE_VAPOR * 0.85, delta)


func _derivar_vapor(nuvem: Node2D, velocidade: float, delta: float) -> void:
	var x: float = nuvem.position.x + velocidade * delta
	if x > 1146.0:
		x = -6.0
	elif x < -6.0:
		x = 1146.0
	nuvem.position.x = x
	nuvem.modulate.a = 0.30 + 0.30 * absf(sin(nuvem.position.x * 0.02))


# --- Tema ---

func _tematizar_placar() -> void:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color("#3A2F25")
	estilo.set_border_width_all(6)
	estilo.border_color = Color("#8A6B44")
	estilo.set_corner_radius_all(3)
	estilo.content_margin_left = 16
	estilo.content_margin_right = 16
	estilo.content_margin_top = 10
	estilo.content_margin_bottom = 10
	estilo.shadow_color = Color(0, 0, 0, 0.45)
	estilo.shadow_size = 10
	estilo.shadow_offset = Vector2(0, 5)
	placar_painel.add_theme_stylebox_override("panel", estilo)


func _tematizar_cabecalho() -> void:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color("#C9A97E")
	estilo.set_border_width_all(4)
	estilo.border_color = Color("#8A6B44")
	estilo.content_margin_left = 8
	estilo.content_margin_right = 8
	estilo.content_margin_top = 8
	estilo.content_margin_bottom = 8
	estilo.shadow_color = Color(0, 0, 0, 0.4)
	estilo.shadow_size = 6
	estilo.shadow_offset = Vector2(0, 4)
	cabecalho.add_theme_stylebox_override("panel", estilo)


func _preparar_botao(botao: Button, texto: String, caminho_icone: String) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("#B08F63")
	normal.set_border_width_all(4)
	normal.border_color = Color("#8A6B44")
	normal.set_corner_radius_all(2)
	normal.content_margin_left = 18
	normal.content_margin_right = 18
	normal.content_margin_top = 12
	normal.content_margin_bottom = 12
	normal.shadow_color = Color(0, 0, 0, 0.4)
	normal.shadow_size = 6
	normal.shadow_offset = Vector2(0, 5)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("#C9A97E")

	var focus := normal.duplicate() as StyleBoxFlat
	focus.bg_color = Color("#C9A97E")
	focus.border_color = COR_OURO

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("#8A6B44")
	pressed.shadow_size = 0
	pressed.shadow_offset = Vector2.ZERO
	pressed.content_margin_top = 14
	pressed.content_margin_bottom = 10

	botao.text = texto
	botao.icon = load(caminho_icone)
	botao.expand_icon = true
	botao.alignment = HORIZONTAL_ALIGNMENT_LEFT
	botao.add_theme_stylebox_override("normal", normal)
	botao.add_theme_stylebox_override("hover", hover)
	botao.add_theme_stylebox_override("pressed", pressed)
	botao.add_theme_stylebox_override("focus", focus)
	botao.add_theme_stylebox_override("disabled", hover)
	botao.add_theme_font_size_override("font_size", 22)
	botao.add_theme_color_override("font_color", Color("#2B2622"))
	botao.add_theme_color_override("font_hover_color", Color("#1F1B17"))
	botao.add_theme_color_override("font_pressed_color", COR_BRANCO)
	botao.add_theme_color_override("font_focus_color", Color("#1F1B17"))
	botao.add_theme_constant_override("h_separation", 20)


# --- Placar ---

func _atualizar_placar() -> void:
	P1.text = "%d" % GameManager.vitorias[0]
	P2.text = "%d" % GameManager.vitorias[1]


# --- Navegação ---

func _iniciar_minigame(caminho: String) -> void:
	GameManager.iniciar_minigame(caminho)


func _on_botao_tiles_falsos_pressed() -> void:
	_iniciar_minigame("res://scenes/minigames/fake tiles.tscn")


func _on_obstacle_pressed() -> void:
	_iniciar_minigame("res://scenes/minigames/obstacle.tscn")
