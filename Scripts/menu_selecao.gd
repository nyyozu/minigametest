extends Control


@onready var P1: Label = $P1
@onready var P2: Label = $P2
@onready var animationp1: AnimatedSprite2D = $P1_SPRITE
@onready var animationp2: AnimatedSprite2D = $P2_SPRITE

func _ready() -> void:
	_atualizar_placar()
	animationp1.play("default")
	animationp2.play("default")

func _atualizar_placar() -> void:
	P1.text = "P1: %d" % GameManager.vitorias[0]
	P2.text = "P2: %d" % GameManager.vitorias[1]
	
func _on_botao_tiles_falsos_pressed() -> void:
	GameManager.iniciar_minigame("res://scenes/minigames/fake tiles.tscn")


func _on_obstacle_pressed() -> void:
	GameManager.iniciar_minigame("res://scenes/minigames/obstacle.tscn")
