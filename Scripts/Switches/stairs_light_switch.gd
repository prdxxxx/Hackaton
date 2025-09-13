extends Node3D

@onready var lights_stairs: Node3D = $"../../ElectricBox/Lights/Lights_Stairs"

var onoff = false

func _ready() -> void:
	SaveLoad._load()
	var onoff2 = SaveLoad.SaveFileData.lights_stairs
	onoff = onoff2
	$off.visible = onoff
	$on.visible = !onoff
	lights_stairs.visible = onoff
	
func toggle_light() -> void:
	onoff = !onoff
	$off.visible = onoff
	$on.visible = !onoff
	lights_stairs.visible = onoff
	SaveLoad.SaveFileData.lights_stairs = onoff
