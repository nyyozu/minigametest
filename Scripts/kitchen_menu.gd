extends Control


@onready var P1: Label = $P1
@onready var P2: Label = $P2
@onready var animationp1: AnimatedSprite2D = $P1_SPRITE
@onready var animationp2: AnimatedSprite2D = $P2_SPRITE
@onready var panelas_btn: Button = $panelas
@onready var utensilios_btn: Button = $utensilios
@onready var escolha: Label = $CenterContainer/VBoxContainer/escolha


func _ready() -> void:
	_atualizar_placar()
	_configurar_animacoes()
	animationp1.play("default")
	animationp2.play("default")
	# Configurar texto dos botões
	panelas_btn.text = "Fake Tiles"
	utensilios_btn.text = "Obstacle"


func _configurar_animacoes() -> void:
	# Criar SpriteFrames para P1 (ChefP1_walk_sheet.png - 4 frames, 64x80 cada)
	var sprite_frames_p1 = SpriteFrames.new()
	sprite_frames_p1.add_animation("default")
	
	var texture_p1 = preload("res://assets/P1/ChefP1_walk_sheet.png")
	for i in 4:
		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = texture_p1
		atlas_texture.region = Rect2(i * 64, 0, 64, 80)
		sprite_frames_p1.add_frame("default", atlas_texture)
	sprite_frames_p1.set_animation_speed("default", 5.0)
	sprite_frames_p1.set_animation_loop("default", true)
	animationp1.sprite_frames = sprite_frames_p1
	
	# Criar SpriteFrames para P2 (ChefP2_walk_sheet.png - 4 frames, 64x80 cada)
	var sprite_frames_p2 = SpriteFrames.new()
	sprite_frames_p2.add_animation("default")
	
	var texture_p2 = preload("res://assets/P2/ChefP2_walk_sheet.png")
	for i in 4:
		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = texture_p2
		atlas_texture.region = Rect2(i * 64, 0, 64, 80)
		sprite_frames_p2.add_frame("default", atlas_texture)
	sprite_frames_p2.set_animation_speed("default", 5.0)
	sprite_frames_p2.set_animation_loop("default", true)
	animationp2.sprite_frames = sprite_frames_p2


func _atualizar_placar() -> void:
	P1.text = "P1: %d" % GameManager.vitorias[0]
	P2.text = "P2: %d" % GameManager.vitorias[1]


func _iniciar_minigame(caminho: String) -> void:
	GameManager.iniciar_minigame(caminho)