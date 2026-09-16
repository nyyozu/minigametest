extends Node3D

@onready var svp_p1: SubViewport = $"Splitscreen/GridContainer/SVPC-P1/SVP-P1"
@onready var svp_p2: SubViewport = $"Splitscreen/GridContainer/SVPC-P2/SVP-P1"

func _ready() -> void:
	svp_p2.world_3d = svp_p1.world_3d
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
