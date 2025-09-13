extends Node3D

@onready var lights_walls: Node3D = $"../../ElectricBox/Lights/Lights_Walls"

var onoff = false

func _ready() -> void:
	SaveLoad._load()
	var onoff2 = SaveLoad.SaveFileData.lights_walls
	onoff = onoff2
	$off.visible = onoff
	$on.visible = !onoff
	lights_walls.visible = onoff
	
func toggle_light() -> void:
	onoff = !onoff
	$off.visible = onoff
	$on.visible = !onoff
	lights_walls.visible = onoff
	SaveLoad.SaveFileData.lights_walls = onoff
