extends Node3D

@onready var lights_storage: Node3D = $"../../ElectricBox/Lights/Lights_Storage"

var onoff = false

func _ready() -> void:
	SaveLoad._load()
	var onoff2 = SaveLoad.SaveFileData.lights_storage
	onoff = onoff2
	$off.visible = onoff
	$on.visible = !onoff
	lights_storage.visible = onoff
	
func toggle_light() -> void:
	onoff = !onoff
	$off.visible = onoff
	$on.visible = !onoff
	lights_storage.visible = onoff
	SaveLoad.SaveFileData.lights_storage = onoff
