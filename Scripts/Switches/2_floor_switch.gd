extends Node3D

@onready var lights_2_floor: Node3D = $"../../ElectricBox/Lights/Lights_2_Floor"

var onoff = false

func _ready() -> void:
	SaveLoad._load()
	var onoff2 = SaveLoad.SaveFileData.lights_2_floor
	onoff = onoff2
	$off.visible = onoff
	$on.visible = !onoff
	lights_2_floor.visible = onoff
	
func toggle_light() -> void:
	onoff = !onoff
	$off.visible = onoff
	$on.visible = !onoff
	lights_2_floor.visible = onoff
	SaveLoad.SaveFileData.lights_2_floor = onoff
